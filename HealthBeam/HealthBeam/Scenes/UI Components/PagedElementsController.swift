//
//  PagedTableView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 4.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PagedElementsControllerSearchDelegate: PagedElementsControllerDelegate {
}

protocol PagedElementsControllerListDelegate: PagedElementsControllerDelegate {
}

extension PagedElementsControllerDelegate where Self: PagedElementsControllerSearchDelegate  {
    func requestPage(_ page: Int, in tableView: UITableView, handler: @escaping ((BatchResult<ElementType>) -> ())) {
       //Empty implementation, this method is no longer applicable for the conforming type
    }
}

extension PagedElementsControllerDelegate where Self: PagedElementsControllerListDelegate {
    func requestPage(_ page: Int, in tableView: UITableView, scopeIndex: Int?, handler: @escaping ((BatchResult<ElementType>) -> ())) {
        //Empty implementation, this method is no longer applicable for the conforming type
    }
}

protocol PagedElementsControllerDelegate: class {
    associatedtype ElementType: Codable
    func cellForItem(_ item: ElementType, in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func cellForPlaceholderItemIn(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func cellHeightIn(tableView: UITableView) -> CGFloat
    
    func requestPage(_ page: Int, in tableView: UITableView, handler: @escaping ((BatchResult<ElementType>) -> ()))
    func requestPage(_ page: Int, in tableView: UITableView, scopeIndex: Int?, handler: @escaping ((BatchResult<ElementType>) -> ()))
    func discardRequestForPage(_ page: Int)
}

private protocol SearchResultHandler: class {
    func updateSearchResults(for searchController: UISearchController)
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
}
//The wrapper is required in order to overcome the contitional conformance
private class SearchResultsUpdatingWrapper: NSObject, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    weak var delegate: SearchResultHandler?
    func updateSearchResults(for searchController: UISearchController) {
        if let delegate = delegate {
            delegate.updateSearchResults(for: searchController)
        }
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if let delegate = delegate {
            delegate.searchBar(searchBar, selectedScopeButtonIndexDidChange: selectedScope)
        }
    }
}

private class ApplicationThemedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setApplicationGradientBackground()
    }
}

class PagedElementsController<Delegate: PagedElementsControllerDelegate>: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    enum BarStyle {
        case infered
        case light
    }
    
    private weak var tableView: UITableView?
    private weak var delegate: Delegate?
    private var searchResultsUpdatingWrapper: SearchResultsUpdatingWrapper?
    
    private var modelCollection: [Int: BatchResult<Delegate.ElementType>] = [:]
    private var estimatedCollection: [Int: Int] = [:]
    private var pendingPageRequests: Set<Int> = []
    
    private var searchBar: UISearchBar?
    private var segmentedControl: UISegmentedControl?
    
    private var previousSearchTerm = ""
    
    init(tableView: UITableView, delegate: Delegate) {
        self.delegate = delegate
        self.tableView = tableView
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    func scopeIndex() -> Int? {
        return segmentedControl?.selectedSegmentIndex
    }
    
    func configureScopeSelectionControlWith(scopeTitles: [String], style: BarStyle) {
        
        let containerView = ApplicationThemedView()
        containerView.addConstraintForHeight(44)
        tableView?.tableHeaderView = containerView
        if let tableView = tableView {
            containerView.setEqualWidthTo(view: tableView)
        }
        
        let segmentedControl = UISegmentedControl.init(items: scopeTitles)
        segmentedControl.selectedSegmentIndex = 0
        containerView.addSubview(segmentedControl)
        containerView.addConstraintsForWrappedInsideView(segmentedControl,
                                                         edgeInset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
                                                         pinBottom: false)
        
        switch style {
        case .infered:
            break
        case .light:
            segmentedControl.tintColor = .white
        }
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        self.segmentedControl = segmentedControl
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        reset()
    }
    
    //MARK:- UITableViewDataSource
    
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
            return delegate.cellForItem(element, in: tableView, indexPath: indexPath)
        }
        return delegate.cellForPlaceholderItemIn(tableView: tableView, indexPath: indexPath)
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
    
    func configureSearchBarIn(viewController: UIViewController, style: BarStyle = .infered, scopeTitles: [String]? = nil) {
        let searchController = UISearchController(searchResultsController: nil)
        searchResultsUpdatingWrapper = SearchResultsUpdatingWrapper()
        searchResultsUpdatingWrapper?.delegate = self
        searchController.searchResultsUpdater = searchResultsUpdatingWrapper
        searchController.delegate = searchResultsUpdatingWrapper
        searchController.dimsBackgroundDuringPresentation = false
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
        viewController.navigationItem.searchController = searchController
        viewController.definesPresentationContext = true
        let searchBar = searchController.searchBar
        
        viewController.view.setApplicationGradientBackground()

        switch style {
        case .infered:
            break
        case .light:
            searchBar.barStyle = .black
            searchBar.tintColor = .white
            searchBar.searchBarStyle = .minimal
            
            searchBar.setImage(UIImage(named: "searchIcon"), for: .search, state: .normal)
            searchBar.setImage(UIImage(named: "searchIcon"), for: .resultsList, state: .normal)
            searchBar.setImage(UIImage(named: "cancelIcon"), for: .clear, state: .normal)
        }
        
        if let scopeTitles = scopeTitles {
            configureScopeSelectionControlWith(scopeTitles: scopeTitles, style: style)
        }
        
        searchBar.delegate = searchResultsUpdatingWrapper
        self.searchBar = searchBar
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
            let tableView = tableView,
            let delegate = delegate else {
                return
        }
        if text == previousSearchTerm {
            return
        }
        
        delegate.requestPage(1, in: tableView, scopeIndex: scopeIndex()) { [weak self] batchElement in
            self?.refreshContent(initialBatchResult: batchElement)
            self?.previousSearchTerm = text
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        reset()
    }
}

//MARK: - Utilities

extension PagedElementsController  {
    
    func reset() {
        estimatedCollection = [0:20]
        modelCollection = [:]
        pendingPageRequests = []
        tableView?.reloadData()
        tableView?.layoutIfNeeded()
//        tableView?.beginUpdates()
//        tableView?.endUpdates()
        
    }
    
    func invalidate(referenceBatchResult: BatchResult<Delegate.ElementType>) {
        estimatedCollection = [:]
        //        let ceilValue = referenceBatchResult.currentPage == referenceBatchResult.totalPagesCount ? referenceBatchResult.currentPage : referenceBatchResult.currentPage + 1
        for sectionNumber in 0..<referenceBatchResult.totalPagesCount  {
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
         //   let delegate = delegate,
            let tableView = tableView else {
                return
        }
        pendingPageRequests.insert(section)
        let batchHandler: (BatchResult<Delegate.ElementType>) -> () = { [weak self] batchElement in
            guard let strongSelf = self else {
                return
            }
            
            let currentPageElements = tableView.numberOfRows(inSection: section)
            let newPageElements = batchElement.elementsInPage
            
            let currentPageIndexPaths = (0..<currentPageElements).map() { IndexPath(row: $0, section: section) }
            let newPageIndexPaths = (0..<newPageElements).map() { IndexPath(row: $0, section: section) }
            
            UIView.performWithoutAnimation {
                
                tableView.beginUpdates()
                
                let currentPages = strongSelf.estimatedCollection.count
                strongSelf.invalidate(referenceBatchResult: batchElement)
                let newPages = strongSelf.estimatedCollection.count
                
                if newPages > currentPages {
                    let upperRange = currentPages..<newPages
                    tableView.insertSections(IndexSet(integersIn: upperRange), with: .none)
                }
                if newPages < currentPages {
                    let lowerRange = newPages..<currentPages
                    tableView.deleteSections(IndexSet(integersIn: lowerRange), with: .none)
                }
                
                
                if currentPageElements > newPageElements {
                    let obsoleteIndexPaths = currentPageIndexPaths.filter() { !newPageIndexPaths.contains($0) }
                    tableView.deleteRows(at: obsoleteIndexPaths, with: .none)
                    tableView.scrollToRow(at: obsoleteIndexPaths.last!, at: .bottom, animated: true)
                }
                else if currentPageElements < newPageElements {
                    let newIdexPaths = newPageIndexPaths.filter() { !currentPageIndexPaths.contains($0) }
                    tableView.deleteRows(at: newIdexPaths, with: .none)
                }
                strongSelf.modelCollection[section] = batchElement
                tableView.endUpdates()
                tableView.reloadRows(at: newPageIndexPaths, with: .fade)
            }
            strongSelf.pendingPageRequests.remove(section)
        }
        
        
        if delegate is PagedElementsControllerSearchDelegate {
            delegate?.requestPage(section + 1, in: tableView, scopeIndex: scopeIndex(), handler: batchHandler)
        } else if delegate is PagedElementsControllerListDelegate {
            delegate?.requestPage(section + 1, in: tableView, handler: batchHandler)
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
