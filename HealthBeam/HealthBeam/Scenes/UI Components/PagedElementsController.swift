//
//  PagedTableView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 4.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit


protocol PagedElementsControllerSearchDelegate: PagedElementsControllerDelegate {
    func searchFor(_ searchTerm: String, handler: @escaping ((BatchResult<ElementType>) -> ()))
}


protocol PagedElementsControllerDelegate: class {
    associatedtype ElementType: Codable
    func cellForItem(_ item: ElementType, in tableView: UITableView) -> UITableViewCell
    func cellForPlaceholderItemIn(tableView: UITableView) -> UITableViewCell
    func cellHeightIn(tableView: UITableView) -> CGFloat
    
    func requestPage(_ page: Int, in tableView: UITableView, handler: @escaping ((BatchResult<ElementType>) -> ()))
    func discardRequestForPage(_ page: Int)
}

private protocol SearchResultHandler: class {
    func updateSearchResults(for searchController: UISearchController)
}
//The wrapper is required in order to overcome the contitional conformance
private class SearchResultsUpdatingWrapper: NSObject, UISearchResultsUpdating {
    weak var delegate: SearchResultHandler?
    func updateSearchResults(for searchController: UISearchController) {
        if let delegate = delegate {
            delegate.updateSearchResults(for: searchController)
        }
    }
}

class PagedElementsController<Delegate: PagedElementsControllerDelegate>: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    private weak var tableView: UITableView?
    private weak var delegate: Delegate?
    private var searchResultsUpdatingWrapper: SearchResultsUpdatingWrapper?
    
    private var modelCollection: [Int: BatchResult<Delegate.ElementType>] = [:]
    private var estimatedCollection: [Int: Int] = [:]
    private var pendingPageRequests: Set<Int> = []
    
    init(tableView: UITableView, delegate: Delegate) {
        self.delegate = delegate
        self.tableView = tableView
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
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
        requestPageIfNeededFor(section: indexPath.section)
        if let element = element(for: indexPath) {
            return delegate.cellForItem(element, in: tableView)
        }
        return delegate.cellForPlaceholderItemIn(tableView: tableView)
    }
    
    //MARK:- UITableViewDataSourcePrefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let uniqieSections = Set( indexPaths.map { $0.section } )
        for section in uniqieSections {
            requestPageIfNeededFor(section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let uniqieSections = Set( indexPaths.map { $0.section } )
        for section in uniqieSections {
            pagereRequestCancelationFor(section: section)
        }
    }
}

//MARK: - Searching functionality

extension PagedElementsController: SearchResultHandler where Delegate: PagedElementsControllerSearchDelegate {
    
    func configureSearchBarIn(viewController: UIViewController) {
        let searchController = UISearchController(searchResultsController: nil)
        searchResultsUpdatingWrapper = SearchResultsUpdatingWrapper()
        searchResultsUpdatingWrapper?.delegate = self
        searchController.searchResultsUpdater = searchResultsUpdatingWrapper
        searchController.dimsBackgroundDuringPresentation = false
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
        viewController.navigationItem.searchController = searchController
        viewController.definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
            let delegate = delegate else {
                return
        }
        delegate.searchFor(text) { [weak self] batchElement in
            self?.refreshContent(initialBatchResult: batchElement)
        }
    }
}


//MARK: - Utilities

extension PagedElementsController  {
    
    func invalidate(referenceBatchResult: BatchResult<Delegate.ElementType>) {
        estimatedCollection = [:]
        let ceilValue = referenceBatchResult.currentPage == referenceBatchResult.totalPagesCount ? referenceBatchResult.currentPage : referenceBatchResult.currentPage + 1
        for sectionNumber in 0..<ceilValue {
            estimatedCollection[sectionNumber] = referenceBatchResult.elementsInPage
        }
    }
    
    func refreshContent(initialBatchResult: BatchResult<Delegate.ElementType>) {
        modelCollection = [:]
        invalidate(referenceBatchResult: initialBatchResult)
        modelCollection[initialBatchResult.currentPage - 1] = initialBatchResult
        tableView?.reloadData()
    }
    
    private func requestPageIfNeededFor(section: Int) {
        guard !pendingPageRequests.contains(section),
            modelCollection[section] == nil,
            let delegate = delegate,
            let tableView = tableView else {
                return
        }
        pendingPageRequests.insert(section)
        delegate.requestPage(section + 1, in: tableView) { [weak self] batchElement in
            guard let strongSelf = self else {
                return
            }
            
            tableView.beginUpdates()
            
            let currentPages = strongSelf.estimatedCollection.count
            strongSelf.invalidate(referenceBatchResult: batchElement)
            let newPages = strongSelf.estimatedCollection.count
            
            if newPages > currentPages {
                let upperRange = currentPages..<newPages
                tableView.insertSections(IndexSet(integersIn: upperRange), with: .fade)
            }
            if newPages < currentPages {
                let lowerRange = newPages..<currentPages
                tableView.deleteSections(IndexSet(integersIn: lowerRange), with: .fade)
            }
            tableView.deleteSections(IndexSet(integer: section), with: .none)
            strongSelf.modelCollection[section] = batchElement
            tableView.insertSections(IndexSet(integer: section), with: .none)
            tableView.endUpdates()
            tableView.reloadSections(IndexSet(arrayLiteral: section), with: .fade)
            strongSelf.pendingPageRequests.remove(section)
        }
    }
    
    private func pagereRequestCancelationFor(section: Int) {
        if let delegate = delegate {
            delegate.discardRequestForPage(section + 1)
        }
    }
    
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
