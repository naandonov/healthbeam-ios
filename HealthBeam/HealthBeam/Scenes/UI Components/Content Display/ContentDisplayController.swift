//
//  ContentDisplayController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 8.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class ContentDisplayController: NSObject {
    
    enum DisplayElement {
        case standard(title: String, content: String)
    }
    
    private weak var containerView: UIView?
    private var displayElements: [DisplayElement] = []
    let tableView: UITableView
    
    init(containerView: UIView) {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.containerView = containerView
        super.init()
        setupUI()
    }
    
    private func setupUI() {
        containerView?.addSubview(tableView)
        containerView?.addConstraintsForWrappedInsideView(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.registerNib(StandardContentDisplayTableViewCell.self)
    }
    
    func setDisplayElements(_ displayElements: [DisplayElement]) {
        self.displayElements = displayElements
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension ContentDisplayController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayElements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let displayElement = displayElements[section]
        switch  displayElement {
        case .standard(title: _, content: _):
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let returnCell: UITableViewCell
        let displayElement = displayElements[indexPath.section]
        switch  displayElement {
        case let .standard(title: _, content: content):
            let cell: StandardContentDisplayTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            configureStandardDisplayCell(cell: cell, content: content)
            returnCell = cell
        }
        returnCell.selectionStyle = .none
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let displayElement = displayElements[section]
        switch  displayElement {
        case let .standard(title: title, content: _):
            return title
        }
    }
    
}

//MARK: - UITableViewDelegate

extension ContentDisplayController: UITableViewDelegate {
    
  
    
}

//MARK: - Cell Configurations

private extension ContentDisplayController {
    
    func configureStandardDisplayCell(cell: StandardContentDisplayTableViewCell, content: String) {
        cell.label.text = content
    }
}
