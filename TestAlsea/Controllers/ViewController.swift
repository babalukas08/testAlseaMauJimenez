//
//  ViewController.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ViewController: BaseViewController {

    @IBOutlet weak var magnitudInput: UITextField!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    fileprivate var popoverController: PopupController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedListViewController" {
            if let destination = segue.destination as? FeedListViewController {
                if let data = sender as? EarthquakeResponseModel {
                    destination.dataModel = data.features
                }
            }
        }
        else if segue.identifier == "detailFeed" {
            if let destination = segue.destination as? DetailViewController {
                if let data = sender as? FeedListViewModel {
                    destination.model = data.model
                }
            }
        }
    }

    @IBAction func dateAction(_ sender: UIButton) {
        if sender == btnStartDate {
            self.showDateSelectionPopover(textField: self.startLabel, title: "Selecciona Fecha Inicio")
        }
        else {
            self.showDateSelectionPopover(textField: self.endLabel, title: "Selecciona Fecha Fin")
        }
    }
    
    @IBAction func sendRequest(_ sender: DefaultButton) {
        
        guard let magnitud = self.magnitudInput.text, !magnitud.isEmpty else {
            showMessageDialog("Aviso!", message: "Tienes que llenar todos los campos, para consultar")
            return
        }
        
        guard let startDate = self.startLabel.text, !startDate.isEmpty else {
            showMessageDialog("Aviso!", message: "Tienes que llenar todos los campos, para consultar")
            return
        }
        
        guard let endDate = self.endLabel.text, !endDate.isEmpty else {
            showMessageDialog("Aviso!", message: "Tienes que llenar todos los campos, para consultar")
            return
        }
        
        let model = ResponseModel(start: startDate, end: endDate, min: magnitud)
        
        self.performsRequest(url: model.getRequestString())
    }
    
    @IBAction func lastFeedPressed(_ sender: DefaultButton) {
        let model = self.getLastConsultingDefaults()
        
        if let data = model.model {
            if data.properties?.mag != 0 {
                performSegue(withIdentifier: "detailFeed", sender: model)
            }
            else {
                showMessageDialog("Aviso!", message: "No se tiene ninguna consulta, anterior.")
            }
        }
        else {
            showMessageDialog("Aviso!", message: "No se tiene ninguna consulta, anterior.")
        }
        
    }
    
    // MARK: private methods
    
    fileprivate func performsRequest(url: String) {
        Alamofire.request(ConstantsApp.UrlRequest.baseURl + url)
            .responseString { response in
                switch response.result {
                case .success:
                    if let model = Mapper<EarthquakeResponseModel>().map(JSONString: response.result.value!) {
                        if model.features.count == 0 {
                            self.showMessageDialog("Aviso!", message: "No se encontraron Resultados\nIntentálo con otros parametros")
                        }
                        else {
                            self.performSegue(withIdentifier: "FeedListViewController", sender: model)
                        }
                    }
                    else {
                        self.showMessageDialog("Error", message: "SE produjo un error al consultar, intentalo más tarde.")
                    }
                case .failure(let error):
                    self.showMessageDialog("Error", message: error.localizedDescription)
                }
            }
    }
    
    fileprivate func showDateSelectionPopover(textField: UILabel, title: String) {
        //currentTextField?.resignFirstResponder()
        popoverController = PopupController.create(self)
        popoverController.animation = PopupController.PopupAnimation.fadeIn
        popoverController.scrollable = false
        
        let uiStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let datePickerViewController = uiStoryBoard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        datePickerViewController.textField = textField
        datePickerViewController.titleMenu = title
        datePickerViewController.delegate = self
        _ = popoverController.presentPopupController(datePickerViewController, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}

// MARK: - DatePickerViewControllerDelegate
extension ViewController: DatePickerViewControllerDelegate {
    
    func datePickerViewControllerDidCancel(controller: DatePickerViewController) {
        popoverController.dismissPopupController {
            self.popoverController = nil
        }
    }
    
    func datePickerViewControllerDidSelectDate(controller: DatePickerViewController, date: Date, textField: UILabel?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let textF = textField {
            textF.text = formatter.string(from: date)
        }
        popoverController.dismissPopupController {
            self.popoverController = nil
        }
    }
}

