//
//  PagedTableView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 4.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PagedElementsControllerDelegate: class {
    associatedtype ElementType: Codable
    func cellForItem(_ item: ElementType, in tableView: UITableView) -> UITableViewCell
    func cellForPlaceholderItemIn(tableView: UITableView) -> UITableViewCell
    func cellHeightIn(tableView: UITableView) -> CGFloat
    
}

class PagedElementsController<Delegate: PagedElementsControllerDelegate>: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    private weak var tableView: UITableView?
    weak var delegate: Delegate?
    
    private var modelCollection: [Int: BatchResult<Delegate.ElementType>] = [:]
    private var estimatedCollection: [Int: Int] = [:]

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    func invalidate(initialBatchResult: BatchResult<Delegate.ElementType>) {
        estimatedCollection = [:]
        modelCollection = [:]
        for pageNumber in 0..<initialBatchResult.totalPagesCount {
            estimatedCollection[pageNumber] = initialBatchResult.elementsInPage
        }
        modelCollection[initialBatchResult.currentPage - 1] = initialBatchResult
        tableView?.reloadData()
    }
    
    
    //MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return estimatedCollection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let delegate = delegate else {
            return 0
        }
        return delegate.cellHeightIn(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = delegate else {
            return UITableViewCell()
        }
        
        if let element = element(for: indexPath) {
            return delegate.cellForItem(element, in: tableView)
        }
        return delegate.cellForPlaceholderItemIn(tableView: tableView)
    }
    
    //MARK:- UITableViewDataSourcePrefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
         print("prefetchRowsAt \(indexPaths)")
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("cancelPrefetchingForRowsAt \(indexPaths)")
    }
}

//MARK: - Utilities

extension PagedElementsController {
    
    private func elementsInSection(_ section: Int) -> Int {
        if let batch = modelCollection[section] {
            return batch.elementsInPage
        }
        else if let items = estimatedCollection[section] {
            return items
        }
        return 0
    }
    
    private func element(for indexPath: IndexPath) -> Delegate.ElementType? {
        if let batch = modelCollection[indexPath.section], let element = batch.items[safe: indexPath.row]{
            return element
        }
        return nil
    }
}
