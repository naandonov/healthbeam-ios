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
        case standard(title: String, keyPath: WritableKeyPath<T, String>, keyboardType: UIKeyboardType, isRequired: Bool)
        case standardOptional(title: String, keyPath: WritableKeyPath<T, String?>, keyboardType: UIKeyboardType, isRequired: Bool)
        case multitude(title: String, keyPath: WritableKeyPath<T, [String]>, isRequired: Bool)
        case multitudeOptional(title: String, keyPath: WritableKeyPath<T, [String]?>, isRequired: Bool)
        case datePickerOptional(title: String, keyPath: WritableKeyPath<T, Date?>, isRequired: Bool)
        case itemsPicker(title: String, keyPath: WritableKeyPath<T, String>, model: [String] ,isRequired: Bool)
        case itemsPickerOptional(title: String, keyPath: WritableKeyPath<T, String?>, model: [String] ,isRequired: Bool)
        case notes(title: String, keyPath: WritableKeyPath<T, String>, isRequired: Bool)
        case notesOptional(title: String, keyPath: WritableKeyPath<T, String?>, isRequired: Bool)
    }
    
    init(element: T, inputDescriptors: [InputDescriptor]) {
        self.element = element
        self.inputDescriptors = inputDescriptors
    }
}

enum ModificationError: Error {
    case failedInputValidation
}

class ModificationElementController<T: Codable>: NSObject, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

    
    private var tableView: UITableView?
    private weak var containerView: UIView?
    private let dataSource: ModificationDatasource<T>
    private var keyboardScrollHandler: KeyboardScrollHandler?
    
    private var failedVerificationIndexPaths: [IndexPath] = []
        
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
    
    init(containerView: UIView, dataSource: ModificationDatasource<T>, notificationCenter: NotificationCenter) {
        self.dataSource = dataSource
        super.init()

        let plainTableView = UITableView(frame: .zero, style: .grouped)
        containerView.addSubview(plainTableView)
        containerView.addConstraintsForWrappedInsideView(plainTableView)

        plainTableView.dataSource = self
        plainTableView.delegate = self
        plainTableView.isEditing = true

        plainTableView.registerNib(ModificationElementTableViewCell.self)
        plainTableView.registerNib(AddMoreTableViewCell.self)
        plainTableView.registerNib(NotesTableViewCell.self)
        plainTableView.reloadData()
        
        keyboardScrollHandler = KeyboardScrollHandler(scrollView: plainTableView, notificationCenter: notificationCenter, enableTapToDismiss: false)

        self.tableView = plainTableView
        self.containerView = containerView
    }
    
    func requestModifiedElement() throws -> T? {
        tableView?.firstResponder()?.resignFirstResponder()
        let snapshotFailedInputs = Array(failedVerificationIndexPaths)
        guard isInputValid() else {
            reloadPostValidationCellseFor(indexPaths: Array(Set(snapshotFailedInputs + failedVerificationIndexPaths)))
            throw ModificationError.failedInputValidation
        }
        reloadPostValidationCellseFor(indexPaths: Array(Set(snapshotFailedInputs + failedVerificationIndexPaths)))

        
        for (index, inputDescriptor) in dataSource.inputDescriptors.enumerated() {
            if case let .multitude(_, keyPath, _) = inputDescriptor {
                let content = dataSource.element[keyPath:keyPath]
                dataSource.element[keyPath:keyPath] = content.filter({ $0.count > 0})
                tableView?.reloadSections(IndexSet(integer: index), with: .automatic)
            } else if case let .multitudeOptional(_, keyPath, _) = inputDescriptor {
                let content = dataSource.element[keyPath:keyPath]
                dataSource.element[keyPath:keyPath] = content?.filter({ $0.count > 0})
                tableView?.reloadSections(IndexSet(integer: index), with: .automatic)
            }
        }
        
        return dataSource.element
    }
    
    private func reloadPostValidationCellseFor(indexPaths: [IndexPath]) {
        guard indexPaths.count > 0 else {
            return
        }
        tableView?.reloadRows(at: indexPaths, with: .automatic)
    }
    
    
    private func isInputValid() -> Bool {
        failedVerificationIndexPaths = []
        var shouldFail = false
        for (index, inputDescriptor) in dataSource.inputDescriptors.enumerated() {
            switch inputDescriptor {
            case let .standard(_, keyPath, _, isRequired):
                if !isStringInputValid(keyPath: keyPath, isRequired: isRequired) {
                    failedVerificationIndexPaths.append(IndexPath(row: 0, section: index))
                    shouldFail = true
                }
            case let .standardOptional(_, keyPath, _, isRequired):
                if !isStringOptionalInputValid(keyPath: keyPath, isRequired: isRequired) {
                    failedVerificationIndexPaths.append(IndexPath(row: 0, section: index))
                    shouldFail = true
                }
            case let .multitude(_, keyPath, isRequired):
                let content = dataSource.element[keyPath: keyPath]
                if  isRequired && content.filter({ $0.count > 0}).count == 0  {
                    failedVerificationIndexPaths.append(IndexPath(row: 0, section: index))
                    shouldFail = true
                }
            case let .multitudeOptional(_, keyPath, isRequired):
                let content = dataSource.element[keyPath: keyPath]
                if  isRequired && (content == nil || content?.filter({ $0.count > 0}).count == 0 )  {
                    failedVerificationIndexPaths.append(IndexPath(row: 0, section: index))
                    shouldFail = true
                }
            case let .datePickerOptional(_, keyPath, isRequired):
                let content = dataSource.element[keyPath: keyPath]
                if  isRequired && (content == nil)  {
                    failedVerificationIndexPaths.append(IndexPath(row: 0, section: index))
                    shouldFail = true
                }
            case let .itemsPicker(_, keyPath, _, isRequired):
                if !isStringInputValid(keyPath: keyPath, isRequired: isRequired) {
                    failedVerificationIndexPaths.append(IndexPath(row: 0, section: index))
                    shouldFail = true
                }
            case let .itemsPickerOptional(_, keyPath, _, isRequired):
                if !isStringOptionalInputValid(keyPath: keyPath, isRequired: isRequired) {
                    failedVerificationIndexPaths.append(IndexPath(row: 0, section: index))
                    shouldFail = true
                }
            case let .notes(_, keyPath, isRequired):
                if !isStringInputValid(keyPath: keyPath, isRequired: isRequired) {
                    failedVerificationIndexPaths.append(IndexPath(row: 0, section: index))
                    shouldFail = true
                }
            case let .notesOptional(_, keyPath, isRequired):
                if !isStringOptionalInputValid(keyPath: keyPath, isRequired: isRequired) {
                    failedVerificationIndexPaths.append(IndexPath(row: 0, section: index))
                    shouldFail = true
                }
            }
        }
        return !shouldFail
    }

    private func isStringOptionalInputValid(keyPath: WritableKeyPath<T, String?>, isRequired: Bool) -> Bool {
        let content = dataSource.element[keyPath: keyPath]
        if  isRequired && (content == nil || content?.count == 0)  {
            return false
        }
        return true
    }
    
    private func isStringInputValid(keyPath: WritableKeyPath<T, String>, isRequired: Bool) -> Bool {
        let content = dataSource.element[keyPath: keyPath]
        if isRequired && content.count == 0 {
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
            return dataSource.element[keyPath: keyPath].count + 1
        } else if case let .multitudeOptional(_, keyPath, _) = dataSource.inputDescriptors[section] {
            return (dataSource.element[keyPath: keyPath]?.count ?? 0) + 1
        }
        return 1
    }
    
    //MARK:- UITableViewDatasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputDescriptor = dataSource.inputDescriptors[indexPath.section]
        let returnCell: ModificationBaseTableViewCell
        switch inputDescriptor {
        case let .standard(title, keyPath, keyboardType, _):
            let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let text = dataSource.element[keyPath: keyPath]
            configureStringInputCell(cell: cell, title: title, text: text, keyboardType: keyboardType, indexPath: indexPath)
            returnCell = cell
        case let .standardOptional(title, keyPath, keyboardType, _):
            let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let text = dataSource.element[keyPath: keyPath]
            configureStringInputCell(cell: cell, title: title, text: text, keyboardType: keyboardType, indexPath: indexPath)
            returnCell = cell
        case let .multitude(title, keyPath, _):
            let content = dataSource.element[keyPath: keyPath]
            if indexPath.row < content.count {
                let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                configureMultitudeInputCell(cell: cell, title: title, content: content, indexPath: indexPath)
                returnCell = cell
            } else {
                let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                configureAddMoreCell(cell: cell, indexPath: indexPath)
                returnCell = cell
            }
        case let .multitudeOptional(title, keyPath, _):
            let content: [String]
            if let element = dataSource.element[keyPath: keyPath] {
                content = element
            }
            else {
                content = []
            }
            if indexPath.row < content.count {
                let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                configureMultitudeInputCell(cell: cell, title: title, content: content, indexPath: indexPath)
                returnCell = cell
            } else {
                let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                configureAddMoreCell(cell: cell, indexPath: indexPath)
                returnCell = cell
            }
        case let .datePickerOptional(title, keyPath, _):
            let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let date = dataSource.element[keyPath: keyPath]
            configureDatePickerCell(cell: cell, title: title, date: date, indexPath: indexPath)
            returnCell = cell
        case let .itemsPicker(title, keyPath, _, _):
            let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let text = dataSource.element[keyPath: keyPath]
            configureItemsPicker(cell: cell, title: title, text: text, indexPath: indexPath)
            returnCell = cell
        case let .itemsPickerOptional(title, keyPath, _, _):
            let cell: ModificationElementTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let text = dataSource.element[keyPath: keyPath]
            configureItemsPicker(cell: cell, title: title, text: text, indexPath: indexPath)
            returnCell = cell
        case let .notes(title, keyPath, _):
            let cell: NotesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let text = dataSource.element[keyPath: keyPath]
            configureNotesInputCell(cell: cell, title: title, text: text, indexPath: indexPath)
            returnCell = cell
        case let .notesOptional(title, keyPath, _):
            let cell: NotesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let text = dataSource.element[keyPath: keyPath]
            configureNotesInputCell(cell: cell, title: title, text: text, indexPath: indexPath)
            returnCell = cell
        }
        
        if failedVerificationIndexPaths.contains(indexPath) {
            returnCell.displayFailedVerification()
        } else {
            returnCell.displayValidInput()
        }
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if case let .multitude(_, keyPath, _) = dataSource.inputDescriptors[indexPath.section] {
            if editingStyle == .delete {
                dataSource.element[keyPath: keyPath].remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if indexPath.row == 0 {
                    tableView.reloadRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
                }
                tableView.endUpdates()
            }
            else if editingStyle == .insert {
                tableView.firstResponder()?.resignFirstResponder()
                dataSource.element[keyPath: keyPath].append("")
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        } else if case let .multitudeOptional(_, keyPath, _) = dataSource.inputDescriptors[indexPath.section] {
            if editingStyle == .delete {
                dataSource.element[keyPath: keyPath]?.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if indexPath.row == 0 {
                    tableView.reloadRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
                }
                tableView.endUpdates()
            }
            else if editingStyle == .insert {
                tableView.firstResponder()?.resignFirstResponder()
                dataSource.element[keyPath: keyPath] =  (dataSource.element[keyPath: keyPath] ?? []) + [""]
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if case let .multitude(_, keyPath, _) = dataSource.inputDescriptors[indexPath.section] {
            let content = dataSource.element[keyPath: keyPath]
            return indexPath.row >= content.count ? .insert : .delete
        } else if case let .multitudeOptional(_, keyPath, _) = dataSource.inputDescriptors[indexPath.section] {
            let content = dataSource.element[keyPath: keyPath] ?? []
            return indexPath.row >= content.count ? .insert : .delete
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if case .multitude(_, _, _) = dataSource.inputDescriptors[indexPath.section] {
            return true
        } else if case .multitudeOptional(_, _, _) = dataSource.inputDescriptors[indexPath.section] {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let inputDescriptor = dataSource.inputDescriptors[section]
        switch inputDescriptor {
            
        case .standard(let title, _, _, _):
            return title
        case .standardOptional(let title, _, _, _):
            return title
        case .multitude(let title, _, _):
            return title
        case let .multitudeOptional(title, _, isRequired):
            var output = title
            if isRequired {
                output += "*"
            }
            return output
        case .datePickerOptional(let title, _, _):
            return title
        case .itemsPicker(let title, _, _, _):
            return title
        case .itemsPickerOptional(let title, _, _, _):
            return title
        case let .notes(title, _, isRequired):
            var output = title
            if isRequired {
                output += "*"
            }
            return output
        case let .notesOptional(title, _, isRequired):
            var output = title
            if isRequired {
                output += "*"
            }
            return output
        }
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let inputDescriptor = dataSource.inputDescriptors[indexPath.section]
        if case .notes(_, _, _) = inputDescriptor {
            return 150
        } else if case .notesOptional(_, _, _) = inputDescriptor {
            return 150
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    //MARK:- UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let inputDescriptor = dataSource.inputDescriptors[textField.tag]
        
        switch inputDescriptor {
        case let .datePickerOptional(_, keyPath, _):
            datePicker.date = dataSource.element[keyPath: keyPath] ?? Date()
        case let .itemsPicker(_, keyPath, model, _):
            itemsPicker.tag = textField.tag
            let value = dataSource.element[keyPath: keyPath]
            guard let selectedIndex = model.firstIndex(of: value) else {
                    itemsPicker.selectRow(0, inComponent: 0, animated: false)
                    return true
            }
            itemsPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
        case let .itemsPickerOptional(_, keyPath, model, _):
            itemsPicker.tag = textField.tag
            guard let value = dataSource.element[keyPath: keyPath],
                let selectedIndex = model.firstIndex(of: value) else {
                    itemsPicker.selectRow(0, inComponent: 0, animated: false)
                    return true
            }
            itemsPicker.selectRow(selectedIndex, inComponent: 0, animated: false)

        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        let inputDescriptor = dataSource.inputDescriptors[textField.tag]
        switch inputDescriptor {
        case let .standard(_, keyPath, _, _):
            dataSource.element[keyPath: keyPath] = text
        case let .standardOptional(_, keyPath, _, _):
            dataSource.element[keyPath: keyPath] = text
        case let .multitude(_, keyPath, _):
            guard let indexPath = tableView?.indexPathForRow(at: textField.convert(textField.center, to: tableView)) else {
                return
            }
            dataSource.element[keyPath: keyPath][indexPath.row] = text
        case let .multitudeOptional(_, keyPath, _):
            guard let indexPath = tableView?.indexPathForRow(at: textField.convert(textField.center, to: tableView)) else {
                return
            }
            dataSource.element[keyPath: keyPath]?[indexPath.row] = text
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       nextResponderFromSection(textField.tag)
        
        return true
    }
    
    //MARK:- UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        if case let .notes(_, keyPath, _) = dataSource.inputDescriptors[textView.tag] {
            dataSource.element[keyPath: keyPath] = text
        } else if case let .notesOptional(_, keyPath, _) = dataSource.inputDescriptors[textView.tag] {
            dataSource.element[keyPath: keyPath] = text
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
        } else if case let .itemsPickerOptional(_, _, model, _) = inputDescriptor {
            return model.count
        }
        return 0
    }
    
    //MARK:- UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let inputDescriptor = dataSource.inputDescriptors[pickerView.tag]
        if case let .itemsPicker(_, _, model, _) = inputDescriptor {
            return model[row]
        } else if case let .itemsPickerOptional(_, _, model, _) = inputDescriptor {
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
        tableView?.endEditing(true)
        let inputDescriptor = dataSource.inputDescriptors[barButton.tag]
        switch inputDescriptor {
        case let .datePickerOptional(_, keyPath, _):
            dataSource.element[keyPath: keyPath] = datePicker.date
        case let .itemsPicker(_, keyPath, model, _):
            dataSource.element[keyPath: keyPath] = model[itemsPicker.selectedRow(inComponent: 0)]
        case let .itemsPickerOptional(_, keyPath, model, _):
            dataSource.element[keyPath: keyPath] = model[itemsPicker.selectedRow(inComponent: 0)]
        default:
            break
        }
        nextResponderFromSection(barButton.tag)
        tableView?.reloadSections(IndexSet(integer: barButton.tag), with: .automatic)
    }
}

//MARK:- Cells Configurations

extension ModificationElementController {
    
    private func configureStringInputCell(cell: ModificationElementTableViewCell, title: String, text: String?, keyboardType: UIKeyboardType, indexPath: IndexPath) {
        cell.textField.text = text
        cell.textField.keyboardType = keyboardType
        cell.textField.attributedPlaceholder = NSAttributedString(string: "\("Enter".localized()) \(title)")
        cell.textField.delegate = self
        cell.textField.tag = indexPath.section
        
        if indexPath.section < dataSource.inputDescriptors.count - 1 {
            cell.textField.returnKeyType = .next
        }
    }
    
    private func configureMultitudeInputCell(cell: ModificationElementTableViewCell, title: String, content: [String], indexPath: IndexPath) {
        let title = indexPath.row == 0 ? title : ""
        configureStringInputCell(cell: cell, title: title, text: content[indexPath.row], keyboardType: .default, indexPath: indexPath)
        cell.textField.attributedPlaceholder = NSAttributedString(string: "Enter New".localized())
    }
    
    private func configureAddMoreCell(cell: ModificationElementTableViewCell, indexPath: IndexPath) {
        cell.textField.text = "Add".localized()
        cell.textField.isUserInteractionEnabled = false
    }
    
    private func configureDatePickerCell(cell: ModificationElementTableViewCell, title: String, date: Date?, indexPath: IndexPath) {
        let text = date?.simpleDateString() ?? ""
        configureStringInputCell(cell: cell, title: title, text: text, keyboardType: .default, indexPath: indexPath)
        cell.textField.tintColor = .clear
        cell.textField.canPerformActions = false
        configureDatePicker(cell.textField, indexPath: indexPath)
    }
    
    private func configureItemsPicker(cell: ModificationElementTableViewCell, title: String, text: String?, indexPath: IndexPath) {
        configureStringInputCell(cell: cell, title: title, text: text, keyboardType: .default, indexPath: indexPath)
        cell.textField.tintColor = .clear
        cell.textField.canPerformActions = false
        configureElementsPicker(cell.textField, indexPath: indexPath)
    }
    
    private func configureNotesInputCell(cell: NotesTableViewCell, title: String, text: String?, indexPath: IndexPath) {
        cell.textView.text = text
        cell.textView.delegate = self
        cell.textView.tag = indexPath.section
    }
    
}

//Utilities

extension ModificationElementController {
    private func nextResponderFromSection(_ section: Int) {
//        let nextIndex = IndexPath(row: 0, section: section + 1)
//        if let cell = tableView?.cellForRow(at: nextIndex) as? ModificationElementTableViewCell {
//            cell.textField.becomeFirstResponder()
//        } else if let cell = tableView?.cellForRow(at: nextIndex) as? NotesTableViewCell {
//            cell.textView.becomeFirstResponder
//        }
    }
}
