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

class ModificationElementController<T: Codable>: NSObject, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var tableView: UITableView?
    private weak var containerView: UIView?
    private let dataSource: ModificationDatasource<T>
    private weak var owner: UIViewController?
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private lazy var itemsPicker: UIPickerView = { [weak self] in
        let elementsPicker = UIPickerView()
        elementsPicker.dataSource = self
        elementsPicker.delegate = self
        return elementsPicker
    }()
    
    init(containerView: UIView, dataSource: ModificationDatasource<T>, owner: UIViewController) {
        self.dataSource = dataSource
        self.owner = owner
        super.init()

        let plainTableView = UITableView(frame: .zero, style: .plain)
        containerView.addSubview(plainTableView)
        containerView.addConstraintsForWrappedInsideView(plainTableView)

        plainTableView.dataSource = self
        plainTableView.delegate = self
        plainTableView.isEditing = true

        plainTableView.registerNib(ModificationElementTableViewCell.self)
        plainTableView.registerNib(AddMoreTableViewCell.self)
        plainTableView.reloadData()

        self.tableView = plainTableView
        self.containerView = containerView
    }
    
    func requestModifiedElement() -> T? {
        tableView?.firstResponder()?.resignFirstResponder()
        tableView?.reloadData()
        guard inputIsValud() else {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.inputDescriptors.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case let .multitude(_, keyPath, _) = dataSource.inputDescriptors[section] {
            return (dataSource.element[keyPath: keyPath]?.count ?? 0) + 1
        }
        return 1
    }
    
    //MARK:- UITableViewDatasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.textField.inputView = nil
        cell.textField.inputAccessoryView = nil
        let inputDescriptor = dataSource.inputDescriptors[indexPath.section]
        let cellTitle: String
        switch inputDescriptor {
        case let .standard(title, keyPath, isRequired):
            cellTitle = title
            break
        case let .standardOptional(title, keyPath, isRequired):
            cellTitle = title
            cell.textField.text = dataSource.element[keyPath: keyPath]

        case let .multitude(title, keyPath, isRequired):
            let content: [String]
            if let element = dataSource.element[keyPath: keyPath] {
                content = element
            }
            else {
                content = []
            }
            if indexPath.row < content.count {
                cellTitle = indexPath.section == 0 ? title : ""
                cell.textField.text = content[indexPath.row]
                cell.textField.tag = indexPath.section
            } else {
                let addCell: AddMoreTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                addCell.addMoreButton.tag = indexPath.section
                return addCell
            }
        case let .datePicker(title, keyPath, isRequired):
            cellTitle = title
            cell.textField.text = dataSource.element[keyPath: keyPath]?.simpleDateString() ?? ""
            configureDatePicker(cell.textField, indexPath: indexPath)
            
        case let .itemsPicker(title, keyPath, model, isRequired):
            cellTitle = title
            cell.textField.text = dataSource.element[keyPath: keyPath] ?? ""
            configureElementsPicker(cell.textField, indexPath: indexPath)
            break
        }
        cell.textField.delegate = self
        cell.textField.tag = indexPath.section
        cell.titleLabel.text = cellTitle
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard case let .multitude(_, keyPath, _) = dataSource.inputDescriptors[indexPath.section] else {
            return
        }
        
        if editingStyle == .delete {
            dataSource.element[keyPath: keyPath]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
        }
        else if editingStyle == .insert {
            tableView.firstResponder()?.resignFirstResponder()
            dataSource.element[keyPath: keyPath] =  (dataSource.element[keyPath: keyPath] ?? []) + [""]
            tableView.insertRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if case let .multitude(_, keyPath, _) = dataSource.inputDescriptors[indexPath.section] {
            let content = dataSource.element[keyPath: keyPath] ?? []
            if indexPath.row >= content.count {
                return .insert
            } else {
                return .delete
            }
        }
        
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if case .multitude(_, _, _) = dataSource.inputDescriptors[indexPath.section] {
            return true
        }
        return false
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inputDescriptor = dataSource.inputDescriptors[indexPath.section]
        if case .datePicker(_, _, _) = inputDescriptor {
            
        }
    }
    
    //MARK:- UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let inputDescriptor = dataSource.inputDescriptors[textField.tag]
        if case let .datePicker(_, keyPath, _) = inputDescriptor {
            datePicker.date = dataSource.element[keyPath: keyPath] ?? Date()
        }
        else if case let .itemsPicker(_, keyPath, model, _) = inputDescriptor {
            itemsPicker.tag = textField.tag
            guard let value = dataSource.element[keyPath: keyPath],
                let selectedIndex = model.firstIndex(of: value) else {
                    itemsPicker.selectRow(0, inComponent: 0, animated: false)
                    return true
            }
            itemsPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        return true
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
            guard let indexPath = tableView?.indexPathForRow(at: textField.convert(textField.center, to: tableView)) else {
                return
            }
            dataSource.element[keyPath: keyPath]?[indexPath.row] = text
        case let .datePicker(title, keyPath, isRequired):
            break
        case let .itemsPicker(title, keyPath, model, isRequired):
            break
        }
    }
    
    //MARK:- UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
     return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let inputDescriptor = dataSource.inputDescriptors[pickerView.tag]
        if case let .itemsPicker(_, _, model, _) = inputDescriptor {
            return model.count
        }
        return 0
    }
    
    //MARK:- UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let inputDescriptor = dataSource.inputDescriptors[pickerView.tag]
        if case let .itemsPicker(_, _, model, _) = inputDescriptor {
            return model[row]
        }
        return ""
    }

    
    //MARK:- Utilities
    
    private func configureDatePicker(_ textField: UITextField, indexPath: IndexPath){
        textField.inputAccessoryView = toolbar(forTag: indexPath.section)
        textField.inputView = datePicker
    }
    
    private func configureElementsPicker(_ textField: UITextField, indexPath: IndexPath){
        textField.inputAccessoryView = toolbar(forTag: indexPath.section)
        textField.inputView = itemsPicker
    }
    
    private func toolbar(forTag tag: Int) -> UIToolbar {
        let toolbar = UIToolbar();
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(self.donePickingDate));
        doneButton.tag = tag
        toolbar.setItems([spaceButton, doneButton], animated: false)
        return toolbar
    }
    
    @objc private func donePickingDate(barButton: UIBarButtonItem) {
        owner?.view.endEditing(true)
        if case let .datePicker(_, keyPath, _) = dataSource.inputDescriptors[barButton.tag] {
            dataSource.element[keyPath: keyPath] = datePicker.date
        }
        else if case let .itemsPicker(_, keyPath, model, _) = dataSource.inputDescriptors[barButton.tag] {
            dataSource.element[keyPath: keyPath] = model[itemsPicker.selectedRow(inComponent: 0)]
        }
        tableView?.reloadSections(IndexSet(integer: barButton.tag), with: .automatic)
    }
}

