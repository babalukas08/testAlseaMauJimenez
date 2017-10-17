//
//  DatePickerViewController.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate: class {
    func datePickerViewControllerDidCancel(controller: DatePickerViewController)
    func datePickerViewControllerDidSelectDate(controller: DatePickerViewController, date: Date, textField: UILabel?)
}

class DatePickerViewController: UIViewController, CardBounceableController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var header: ModAccessoryViewHeader!
    
    weak var delegate: DatePickerViewControllerDelegate?
    var textField: UILabel?
    var titleMenu: String = ""
    
    var initialDate: Date? {
        didSet {
            guard let datePicker = self.datePicker,
                let initialDate = self.initialDate else {
                    return
            }
            
            datePicker.date = initialDate
        }
    }
    
    // CardBounceableController
    var animatingIn: Bool = true
    var cardBounceableTransition: CardBounceableControllerTransition?
    @IBOutlet weak var cardBounceTransitionBg: UIView?
    @IBOutlet weak var cardBounceTransitionCardView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.title = self.titleMenu
        header.delegate = self
        
        if let initialDate = self.initialDate {
            datePicker.date = initialDate
        }
        
        let tapBgRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapBg))
        cardBounceTransitionBg?.addGestureRecognizer(tapBgRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        delegate?.datePickerViewControllerDidCancel(controller: self)
    }
    
    @IBAction func okButtonPressed(_ sender: AnyObject) {
        delegate?.datePickerViewControllerDidSelectDate(controller: self, date: datePicker.date, textField: self.textField)
    }
    
    func onTapBg() {
        delegate?.datePickerViewControllerDidCancel(controller: self)
    }
}

// MARK : - PopupContentViewController

extension DatePickerViewController : PopupContentViewController {
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 300, height: 256)
    }
}

// MARK : - ModAccessoryViewHeaderDelegate

extension DatePickerViewController: ModAccessoryViewHeaderDelegate {
    
    func onTapSecondaryButton(mod: ModAccessoryViewHeader) {
        delegate?.datePickerViewControllerDidSelectDate(controller: self, date: datePicker.date, textField: self.textField)
    }
    
}

