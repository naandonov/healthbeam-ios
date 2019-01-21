//
//  ViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 26.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PagedElementsControllerDelegate, PagedElementsControllerSearchDelegate {
    
    var lastSearchOperation: Operation?
    
    func searchFor(_ searchTerm: String, handler: @escaping ((BatchResult<Patient>) -> ())) {
        if let lastSearchOperation = lastSearchOperation {
            print("cancelation")
            lastSearchOperation.cancel()
        }
        let operation = GetPatientsOperation(searchQuery: searchTerm) { result in
            switch result {
            case let .success(responseObject):
                handler(responseObject.value!)
            case let .failure(error):
                print(error)
            }
        }
        NetworkingManager.shared.addNetwork(operation: operation)
        lastSearchOperation = operation
    }
    
    
    func requestPage(_ page: Int, in tableView: UITableView, handler: @escaping ((BatchResult<Patient>) -> ())) {
        let operation = GetPatientsOperation(pageQuery: page) { result in
            switch result {
            case let .success(responseObject):
                print("New Request: \(page)")
                if let value = responseObject.value {
                    handler(value)
                }
            case let .failure(error):
                log.error(error.description)
                
            }
        }
        NetworkingManager.shared.addNetwork(operation: operation)
    }
    
    func discardRequestForPage(_ page: Int) {
        
    }
    
    func cellForItem(_ item: Patient, in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = item.fullName
        return cell!
    }
    
    func cellForPlaceholderItemIn(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = "Placeholder"
        return cell!
    }
    
    func cellHeightIn(tableView: UITableView) -> CGFloat {
        return 200.0
    }
    
    
    
    
    typealias ElementType = Patient
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var pagedElementsController: PagedElementsController<ViewController>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
      
        
       let searchController = UISearchController(searchResultsController: self)
//        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController
        
        pagedElementsController = PagedElementsController(tableView: tableView, delegate: self)
        pagedElementsController?.configureSearchBarIn(viewController: self)
        
        let operation = GetPatientsOperation { result in
            switch result {
                
            case let .success(responseObject):
                print(responseObject)
                self.pagedElementsController?.refreshContent(initialBatchResult: responseObject.value!)
            case let .failure(error):
                print(error)
                
            }
        }
        NetworkingManager.shared.addNetwork(operation: operation)
        
    }
    
    
    
}

