//
//  ViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 26.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PagedElementsControllerDelegate {
    func cellForItem(_ item: Patient, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = item.fullName
        return cell!
    }
    
    func cellForPlaceholderItemIn(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = "Placeholder"
        return cell!
    }
    
    func cellHeightIn(tableView: UITableView) -> CGFloat {
        return 40.0
    }
    
    
 
    
    typealias ElementType = Patient
    

    @IBOutlet weak var tableView: UITableView!
    
    var pagedElementsController: PagedElementsController<ViewController>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        pagedElementsController = PagedElementsController(tableView: tableView)
        pagedElementsController?.delegate = self
        let operation = GetPatientsOperation { result in
            switch result {
                
            case let .success(responseObject):
                print(responseObject)
                self.pagedElementsController?.invalidate(initialBatchResult: responseObject.value!)
            case let .failure(error):
                print(error)
                
            }
        }
        NetworkingManager.shared.addNetwork(operation: operation)

    }



}

