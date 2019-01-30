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
        case standardOptional(title: String, keyPath: WritableKeyPath<T, String?>, isRequired: Bool)
        case multitude(title: String, keyPath: WritableKeyPath<T, [String]?>, isRequired: Bool)
        case datePicker(title: String, keyPath: WritableKeyPath<T, Date?>, isRequired: Bool)
        case itemsPicker(title: String, keyPath: WritableKeyPath<T, String?>, model: [String] ,isRequired: Bool)
    }
    
    init(element: T, inputDescriptors: [InputDescriptor]) {
        self.element = element
        self.inputDescriptors = inputDescriptors
    }
}

class ModificationElementController<T: Codable>: NSObject, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private var tableView: UITableView?
    private weak var containerView: UIView?
    private let dataSource: ModificationDatasource<T>
    private var activeValidationMarkup = false
    private weak var owner: UIViewController?

    
    init(containerView: UIView, dataSource: ModificationDatasource<T>, owner: UIViewController) {
        self.dataSource = dataSource
        self.owner = owner
        super.init()

        let plainTableView = UITableView(frame: .zero, style: .plain)
        containerView.addSubview(plainTableView)
        containerView.addConstraintsForWrappedInsideView(plainTableView)

        plainTableView.dataSource = self
        plainTableView.delegate = self

        plainTableView.registerNib(ModificationElementTableViewCell.self)
        plainTableView.reloadData()

        self.tableView = plainTableView
        self.containerView = containerView
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
                
            case let .standard(_, keyPath, isRequired):
                if dataSource.element[keyPath: keyPath].count == 0 && isRequired {
                    return false
                }
            case let .standardOptional(_, keyPath, isRequired):
                if !isStringInputValid(keyPath: keyPath, isRequired: isRequired) {
                    return false
                }
            case let .multitude(_, keyPath, isRequired):
                let content = dataSource.element[keyPath: keyPath]
                if  isRequired && (content == nil || content?.count == 0 || content?.first?.count == 0)  {
                    return false
                }
            case let .datePicker(_, keyPath, isRequired):
                let content = dataSource.element[keyPath: keyPath]
                if  isRequired && (content == nil)  {
                    return false
                }
            case let .itemsPicker(_, keyPath, _, isRequired):
                if !isStringInputValid(keyPath: keyPath, isRequired: isRequired) {
                    return false
                }
            }
        }
        return true
    }

    private func isStringInputValid(keyPath: WritableKeyPath<T, String?>, isRequired: Bool) -> Bool {
        let content = dataSource.element[keyPath: keyPath]
        if  isRequired && (content == nil || content?.count == 0)  {
            return false
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
            break
        case let .standardOptional(title, keyPath, isRequired):
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
        case let .multitude(title, keyPath, isRequired):
            break
        case let .datePicker(title, keyPath, isRequired):
            break
        case let .itemsPicker(title, keyPath, model, isRequired):
            break
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
            break
        case let .standardOptional(title, keyPath, isRequired):
            dataSource.element[keyPath: keyPath] = text
        case let .multitude(title, keyPath, isRequired):
            break
        case let .datePicker(title, keyPath, isRequired):
            break
        case let .itemsPicker(title, keyPath, model, isRequired):
            break
        }
    }
    
}

