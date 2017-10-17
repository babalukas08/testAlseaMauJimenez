//
//  FeedListViewController.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class FeedListViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var collectionModel: CollectionModel = CollectionModel()
    var collectionViewDataSource: ModGenericCollectionViewDataSource?
    var dataModel : [FeaturesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewController" {
            if let destination = segue.destination as? DetailViewController {
                if let data = sender as? FeaturesModel {
                    destination.model = data
                }
            }
            
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // MARK: config Collection
    func configureCollectionView() {
        // Configure the Collection model
        if collectionModel.sections.count > 0 {
            collectionModel.removeAll()
        }
        collectionModel.collectionView = collectionView
        
        // Configure the CollectionView data source
        collectionViewDataSource = ModGenericCollectionViewDataSource(collectionView: collectionView, collectionModel: collectionModel)
        collectionViewDataSource?.useStickyHeaders = true
        collectionViewDataSource?.collectionView = self.collectionView
        collectionViewDataSource?.collectionModel = self.collectionModel
        collectionViewDataSource?.delegate = self
        
        // Register cell types
        // Header cell
        collectionViewDataSource?.registerCellClass(
            cellType: FeedListCellType.ListView.rawValue,
            cellClass: ModCollectionViewCell<FeedListView>.self)
        
        createSection(sectionId: "ListSection")
        createCells()
        collectionView.reloadData()
    }
    
    // Header Section
    func createSection(sectionId: String) {
        let listSection = CollectionSectionModel()
        listSection.sectionId = sectionId
        collectionModel.addSection(listSection)
    }
    
    func createCells() {
        createFormCell()
    }
    
    // HeaderLateralMenuModel
    func createFormCell(){
        if let headerSection = collectionModel.getSectionById(id: "ListSection") {
            
            for item in dataModel {
                var headerModel = FeedListViewModel()
                headerModel.model = item
                headerSection.append(item: createForm(content: headerModel))
            }
            
        }
    }
    
    func createForm(content: FeedListViewModel) -> CollectionItemModel {
        let listCountryCell = CollectionItemModel(FeedListCellType.ListView.rawValue, "feedCell")
        listCountryCell.size = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(95))
        listCountryCell.referenceModel = content
        // The model to configure the cell
        listCountryCell.cellModel = content
        
        // The configuration block
        listCountryCell.configureBlock = { cellView, bannerCell in
            guard let cellView = cellView as? ModCollectionViewCell<FeedListView> else {
                return
            }
            
            guard let cellModel = bannerCell?.cellModel as? FeedListViewModel else {
                return
            }
            
            cellView.mod?.configure(cellModel)
            //cellView.mod?.delegate = self
        }
        
        return listCountryCell
    }
    
    fileprivate func performsRequest(url: String) {
        print("\n\n url: \(url) \n\n\n")
        Alamofire.request(url)
            .responseString { response in
                switch response.result {
                case .success:
                    if let model = Mapper<FeaturesModel>().map(JSONString: response.result.value!) {
                        if let properties = model.properties {
                            if properties.mag == 0 {
                                self.showMessageDialog("Aviso!", message: "No se encontraron Resultados\nIntentálo con otros parametros")
                            }
                            else {
                                self.performSegue(withIdentifier: "DetailViewController", sender: model)
                                print("\n\n\n\n Si funciona este es el model: \(properties) \n\n\n\n")
                            }
                        }
                        else {
                            self.showMessageDialog("Aviso!", message: "No se encontraron Resultados\nIntentálo con otros parametros")
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

//MARK: ModGenericCollectionViewDataSourceDelegate
extension FeedListViewController: ModGenericCollectionViewDataSourceDelegate {
    
    func onTapCell(cell: CollectionItemModel, indexPath: IndexPath) {
        guard let referenceModel = cell.referenceModel as? FeedListViewModel else {
            return
        }
        
        if let url = referenceModel.model?.properties?.detail {
            self.performsRequest(url: url)
        }
        
    }
    
    func onShouldPaginate(dataSource: ModGenericCollectionViewDataSource) {}
    
}
