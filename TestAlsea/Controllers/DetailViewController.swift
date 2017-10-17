//
//  DetailViewController.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {

    @IBOutlet weak var summaryData: FeedListView!
    var model: FeaturesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let modelData = self.model {
            var modelFeed = FeedListViewModel()
            modelFeed.model = modelData
            //self.saveLastConsultingDefaults(modelFeed)
            summaryData.configure(modelFeed)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
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
