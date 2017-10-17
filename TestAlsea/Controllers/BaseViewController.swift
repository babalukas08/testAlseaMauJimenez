//
//  BaseViewController.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Alert messages
    func showMessageDialog(_ title: String, message: String, okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: okHandler))
        if cancelHandler != nil {
            alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: cancelHandler))
        }
        present(alertViewController, animated: true, completion: nil)
    }
    
    func getLastConsultingDefaults() -> FeedListViewModel {
        var model: FeedListViewModel = FeedListViewModel()
        
        let defaults = UserDefaults.standard
        if let url = defaults.object(forKey: "last") as? FeedListViewModel {
            model = url
        }
        return model
    }
    
    func saveLastConsultingDefaults(_ model: FeedListViewModel) {
        print("\n\n\n\n\n\nmodel: \(model)\n\n\n\n\n\n")
        
        let defaults = UserDefaults.standard
        defaults.set(model, forKey: "last")//set(model, forKey: "lastData")
        defaults.synchronize()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
