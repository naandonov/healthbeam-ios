//
//  ModificationElementController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class ModificationDatasource<T: Codable> {
    var element: T
    let inputDescriptors: [InputDescriptor]
    enum InputDescriptor {
        case standard(title: String, keyPath: WritableKeyPath<T, String>, isRequired: Bool)
    }
    
    init(element: T, inputDescriptors: [InputDescriptor]) {
        self.element = element
        self.inputDescriptors = inputDescriptors
    }
}

class ModificationElementController<T: Codable>: NSObject, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private weak var tableView: UITableView?
    private let dataSource: ModificationDatasource<T>
    private var activeValidationMarkup = false
    
    init(tableView: UITableView, dataSource: ModificationDatasource<T>) {
        self.dataSource = dataSource
        super.init()
        self.tableView = tableView
        
        tableView.dataSource = self
//        tableView.delegate = self
        
        tableView.registerNib(ModificationElementTableViewCell.self)
        tableView.reloadData()
    }
    
    func requestModifiedElement() -> T? {
        tableView?.firstResponder()?.resignFirstResponder()
        tableView?.reloadData()
        guard inputIsValud() else {
            activeValidationMarkup = true
            tableView?.reloadData()
            activeValidationMarkup = false
            return nil
        }
        
        return dataSource.element
    }
    
    private func inputIsValud() -> Bool {
        for inputDescriptor in dataSource.inputDescriptors {
            switch inputDescriptor {
                
            case let .standard(title, keyPath, isRequired):
                if isRequired && dataSource.element[keyPath: keyPath].count == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    //MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.inputDescriptors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let inputDescriptor = dataSource.inputDescriptors[indexPath.row]
        switch inputDescriptor {

        case let .standard(title, keyPath, isRequired):
            cell.titleLabel.text = title
            cell.textField.tag = indexPath.row
            cell.textField.delegate = self
            cell.textField.text = dataSource.element[keyPath: keyPath]
            
            if activeValidationMarkup && isRequired {
                cell.backgroundColor = .red
            }
            else {
                cell.backgroundColor = .white
            }
        }
        
        
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        let inputDescriptor = dataSource.inputDescriptors[textField.tag]
        switch inputDescriptor {
        case let .standard(title, keyPath, isRequired):
            dataSource.element[keyPath: keyPath] = text
        }
    }
    
}

