//
//  PopupController.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit

typealias PopupAnimateCompletion =  () -> ()

// MARK: - Protocols
/** PopupContentViewController:
Every ViewController which is added on the PopupController must need to be conformed this protocol.
*/
public protocol PopupContentViewController {
    
    /** sizeForPopup(popupController: size: showingKeyboard:):
     return view's size
     */
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize
}

/** PopupControllerDelegate:
 This delegate perfoms when PopupController is showed and closed.
 */
@objc protocol PopupControllerDelegate {
    @objc optional func popupControllerDidClose() -> Void
    @objc optional func popupControllerDidShow() -> Void
}

open class PopupController: UIViewController {
    
    public enum PopupLayout {
        case top, center, bottom
        
        func origin(_ view: UIView, size: CGSize = UIScreen.main.bounds.size) -> CGPoint {
            switch self {
            case .top: return CGPoint(x: (size.width - view.frame.width) / 2, y: 0)
            case .center: return CGPoint(x: (size.width - view.frame.width) / 2, y: (size.height - view.frame.height) / 2)
            case .bottom: return CGPoint(x: (size.width - view.frame.width) / 2, y: size.height - view.frame.height)
            }
        }
    }
    
    public enum PopupAnimation {
        case fadeIn, slideUp
    }
    
    public enum PopupBackgroundStyle {
        case blackFilter(alpha: CGFloat)
        case blur(style: UIBlurEffectStyle)
    }
    
    // MARK: - Public variables
    open var popupView: UIView!
    open var scrollable: Bool = true
    open var tappable: Bool = true
    open var layout: PopupLayout = .center
    open var animation: PopupAnimation = .slideUp
    open var movesAlongWithKeyboard: Bool = true
    open var backgroundStyle: PopupBackgroundStyle = .blackFilter(alpha: 0.4)
    
    weak var delegate: PopupControllerDelegate?
    
    // MARK: - Private variables
    fileprivate let margin: CGFloat = 16
    fileprivate var baseScrollView = UIScrollView()
    fileprivate var isShowingKeyboard: Bool = false
    fileprivate var defaultContentOffset = CGPoint.zero
    
    fileprivate var contentWidthConstraint: NSLayoutConstraint!
    fileprivate var contentHeightConstraint: NSLayoutConstraint!
    
    
    fileprivate var maximumSize: CGSize {
        get {
            return CGSize(
                width: UIScreen.main.bounds.size.width - margin * 2,
                height: UIScreen.main.bounds.size.height - margin * 2
            )
        }
    }
    
    deinit {
        self.removeFromParentViewController()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Overrides
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationObserve()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //updateLayouts()
    }
    
}

// MARK: - Public
public extension PopupController {
    
    // MARK: Classes
    public class func create(_ parentViewController: UIViewController) -> PopupController {
        let controller = PopupController()
        
        parentViewController.addChildViewController(controller)
        parentViewController.view.addSubview(controller.view)
        controller.didMove(toParentViewController: parentViewController)
        
        return controller
    }
    
    // MARK: Instances
    public func presentPopupController(_ viewController: UIViewController, completion: ((Void) -> Void)?) -> PopupController {
        self.addChildViewController(viewController)
        popupView = viewController.view
        configure()
        
        viewController.didMove(toParentViewController: self)
        
        self.show(layout, animation: animation) { () -> () in
            self.defaultContentOffset = self.baseScrollView.contentOffset
            self.delegate?.popupControllerDidShow?()
            completion?()
        }
        return self
    }
    
    public func dismissPopupController(_ completion: (() -> Void)? = nil) {
        if isShowingKeyboard {
            popupView.endEditing(true)
        }
        
        self.closePopup({ () -> Void in
            completion?()
        })
    }
    
    public func closePopup(_ completion: (() -> Void)?) {
        hide(animation) { () -> () in
            self.didClosePopup()
            completion?()
        }
    }
    
    func updatePopoverSize() {
        guard let child = self.childViewControllers.last as? PopupContentViewController else {
            return
        }
        
        guard let _ = contentWidthConstraint else {
            return
        }
        guard let _ = contentHeightConstraint else {
            return
        }
        popupView.removeConstraint(contentWidthConstraint)
        popupView.removeConstraint(contentHeightConstraint)
        
        let size = child.sizeForPopup(self, size: maximumSize, showingKeyboard: isShowingKeyboard)
        contentWidthConstraint = NSLayoutConstraint(item: popupView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.width)
        
        contentHeightConstraint = NSLayoutConstraint(item: popupView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.height)
        
        popupView.addConstraint(contentWidthConstraint)
        popupView.addConstraint(contentHeightConstraint)
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.popupView.layoutIfNeeded()
        }) 
    }
    
}

// MARK: Privates
private extension PopupController {
    
    func configure() {
        view.isHidden = true
        view.frame = UIScreen.main.bounds
        
        if scrollable {
            baseScrollView.isScrollEnabled = true
            baseScrollView.alwaysBounceHorizontal = false
            baseScrollView.alwaysBounceVertical = true
            baseScrollView.delegate = self
        }
        baseScrollView.frame = view.frame
        baseScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        
        switch self.backgroundStyle {
        case .blackFilter(let alpha):
            baseScrollView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        case .blur(let style):
            let effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
            effectView.frame = view.frame
            view.addSubview(effectView)
        }
        
        view.addSubview(baseScrollView)
        baseScrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        popupView.layer.cornerRadius = 2
        popupView.layer.masksToBounds = true
        popupView.frame.origin.y = 0
        
        guard let child = self.childViewControllers.last as? PopupContentViewController else {
            return
        }
        let size = child.sizeForPopup(self, size: maximumSize, showingKeyboard: isShowingKeyboard)
        
        baseScrollView.addSubview(popupView)
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        contentWidthConstraint = NSLayoutConstraint(item: popupView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.width)
        
        contentHeightConstraint = NSLayoutConstraint(item: popupView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.height)
        
        popupView.addConstraint(contentWidthConstraint)
        popupView.addConstraint(contentHeightConstraint)
        
        let horizontalConstraint = NSLayoutConstraint(item: popupView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: baseScrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
        
        let verticalConstraint = NSLayoutConstraint(item: popupView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: baseScrollView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
        
        baseScrollView.addConstraint(horizontalConstraint)
        baseScrollView.addConstraint(verticalConstraint)
    }
    
    func setupNotificationObserve() {
        NotificationCenter.default
            .addObserver(self,
                selector: #selector(PopupController.popupControllerWillShowKeyboard(_:)),
                name: NSNotification.Name.UIKeyboardWillShow,
                object: nil
        )
        NotificationCenter.default
            .addObserver(self,
                selector: #selector(PopupController.popupControllerWillHideKeyboard(_:)),
                name: NSNotification.Name.UIKeyboardWillHide,
                object: nil
        )
        NotificationCenter.default
            .addObserver(self,
                selector: #selector(PopupController.popupControllerDidHideKeyboard(_:)),
                name: NSNotification.Name.UIKeyboardDidHide,
                object: nil
        )
    }
    
    func registerTapGesture() {
        guard tappable else { return }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PopupController.didTapGesture(_:)))
        gestureRecognizer.delegate = self
        baseScrollView.addGestureRecognizer(gestureRecognizer)
    }
    
    func updateLayouts() {
        guard let child = self.childViewControllers.last as? PopupContentViewController else {
            return
        }
        popupView.frame.size = child.sizeForPopup(self, size: maximumSize, showingKeyboard: isShowingKeyboard)
        baseScrollView.contentInset.top = layout.origin(popupView).y
        defaultContentOffset.y = -baseScrollView.contentInset.top
    }
    
    @objc func popupControllerWillShowKeyboard(_ notification: Notification) {
        isShowingKeyboard = true
        //        let obj = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        //
        //        if needsToMoveFrom(obj.CGRectValue().origin) {
        //            move(obj.CGRectValue().origin)
        //        }
        
        //new code to admin the keyboard
        let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let topToolBarSpace:CGFloat = 20.0
        let keyBoardMenusSearchContainer = keyboardSize.height - topToolBarSpace
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0.0, keyBoardMenusSearchContainer , 0.0)
        baseScrollView.contentInset = contentInsets
        let heigthSpace = (baseScrollView.frame.height - keyBoardMenusSearchContainer ) - popupView.frame.height
        popupView.frame.origin.y = heigthSpace / 2
        
    }
    
    @objc func popupControllerWillHideKeyboard(_ notification: Notification) {
        // back()
        
        //new code to admin the keyboard
        guard let child = childViewControllers.last as? PopupContentViewController else {
            return
        }
        popupView.frame.size = child.sizeForPopup(self, size: maximumSize, showingKeyboard: isShowingKeyboard)
        popupView.frame.origin.y = layout.origin(popupView).y
    }
    
    @objc func popupControllerDidHideKeyboard(_ notification: Notification) {
        self.isShowingKeyboard = false
    }
    
    // Tap Gesture
    @objc func didTapGesture(_ sender: UITapGestureRecognizer) {
        self.closePopup { () -> Void in
        }
    }
    
    func didClosePopup() {
        popupView.endEditing(true)
        popupView.removeFromSuperview()
        
        childViewControllers.forEach { $0.removeFromParentViewController() }
        
        view.isHidden = true
        delegate?.popupControllerDidClose?()
        
        self.removeFromParentViewController()
    }
    
    func show(_ layout: PopupLayout, animation: PopupAnimation, completion: @escaping PopupAnimateCompletion) {
        guard let childViewController = childViewControllers.last as? PopupContentViewController else {
            return
        }
        
        popupView.frame.size = childViewController.sizeForPopup(self, size: maximumSize, showingKeyboard: isShowingKeyboard)
        popupView.frame.origin.x = layout.origin(popupView!).x
        
        self.registerTapGesture()
        switch animation {
        case .fadeIn:
            fadeIn(layout, completion: { () -> Void in
                completion()
            })
        case .slideUp:
            slideUp(layout, completion: { () -> Void in
                completion()
            })
        }
    }
    
    func hide(_ animation: PopupAnimation, completion: @escaping PopupAnimateCompletion) {
        guard let child = childViewControllers.last as? PopupContentViewController else {
            return
        }
        
        popupView.frame.size = child.sizeForPopup(self, size: maximumSize, showingKeyboard: isShowingKeyboard)
        popupView.frame.origin.x = layout.origin(popupView).x
        
        switch animation {
        case .fadeIn:
            self.fadeOut({ () -> Void in
                self.clean()
                completion()
            })
        case .slideUp:
            self.slideOut({ () -> Void in
                self.clean()
                completion()
            })
        }
        
    }
    
    func needsToMoveFrom(_ origin: CGPoint) -> Bool {
        guard movesAlongWithKeyboard else {
            return false
        }
        return (popupView.frame.maxY + layout.origin(popupView).y) > origin.y
    }
    
    func move(_ origin: CGPoint) {
        guard let child = childViewControllers.last as? PopupContentViewController else {
            return
        }
        popupView.frame.size = child.sizeForPopup(self, size: maximumSize, showingKeyboard: isShowingKeyboard)
        baseScrollView.contentInset.top = origin.y - popupView.frame.height
        baseScrollView.contentOffset.y = -baseScrollView.contentInset.top
        defaultContentOffset = baseScrollView.contentOffset
    }
    
    func back() {
        guard let child = childViewControllers.last as? PopupContentViewController else {
            return
        }
        popupView.frame.size = child.sizeForPopup(self, size: maximumSize, showingKeyboard: isShowingKeyboard)
        baseScrollView.contentInset.top = layout.origin(popupView).y
        defaultContentOffset.y = -baseScrollView.contentInset.top
    }
    
    func clean() {
        popupView.endEditing(true)
        popupView.removeFromSuperview()
        baseScrollView.removeFromSuperview()
    }
    
}

// MARK: Animations
private extension PopupController {
    
    func fadeIn(_ layout: PopupLayout, completion: @escaping () -> Void) {
        //TODO: Check here
        //        baseScrollView.contentInset.top = layout.origin(popupView).y
        
        view.isHidden = false
        popupView.alpha = 0.0
        popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        baseScrollView.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.popupView.alpha = 1.0
            self.baseScrollView.alpha = 1.0
            self.popupView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (finished) -> Void in
                completion()
        }
    }
    
    func slideUp(_ layout: PopupLayout, completion: @escaping () -> Void) {
        view.isHidden = false
        baseScrollView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        baseScrollView.contentInset.top = layout.origin(popupView).y
        baseScrollView.contentOffset.y = -UIScreen.main.bounds.height
        
        UIView.animate(
            withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
                self.baseScrollView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.baseScrollView.contentOffset.y = -layout.origin(self.popupView).y
                self.defaultContentOffset = self.baseScrollView.contentOffset
            }, completion: { (isFinished) -> Void in
                completion()
        })
    }
    
    func fadeOut(_ completion: @escaping () -> Void) {
        
        UIView.animate(
            withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.popupView.alpha = 0.0
                self.baseScrollView.alpha = 0.0
                self.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { (finished) -> Void in
                completion()
        }
    }
    
    func slideOut(_ completion: @escaping () -> Void) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveLinear, animations: { () -> Void in
            //self.popupView.frame.origin.y = UIScreen.mainScreen().bounds.height
            self.baseScrollView.alpha = 0.0
            }, completion: { (isFinished) -> Void in
                completion()
        })
    }
}

// MARK: UIScrollViewDelegate methods
extension PopupController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta: CGFloat = defaultContentOffset.y - scrollView.contentOffset.y
        if delta > 20 && isShowingKeyboard {
            popupView.endEditing(true)
            return
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let delta: CGFloat = defaultContentOffset.y - scrollView.contentOffset.y
        if delta > 50 {
            baseScrollView.contentInset.top = -scrollView.contentOffset.y
            animation = .slideUp
            self.closePopup({ () -> Void in
            })
        }
    }
    
}

extension PopupController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return gestureRecognizer.view == touch.view
    }
}

extension UIViewController {
    func popupController() -> PopupController? {
        var localParent = self.parent
        while !(localParent is PopupController || localParent == nil) {
            localParent = localParent!.parent
        }
        return parent as? PopupController
    }
}
