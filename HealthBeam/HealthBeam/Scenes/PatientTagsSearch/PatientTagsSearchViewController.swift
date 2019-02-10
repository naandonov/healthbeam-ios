//
//  PatientTagsSearchViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias PatientTagsSearchInteractorProtocol = PatientTagsSearchBusinessLogic & PatientTagsSearchDataStore
typealias PatientTagsSearchPresenterProtocol =  PatientTagsSearchPresentationLogic
typealias PatientTagsSearchRouterProtocol = PatientTagsSearchRoutingLogic & PatientTagsSearchDataPassing

protocol PatientTagsSearchDisplayLogic: class {
    func displayNearbyTags(viewModel: PatientTagsSearch.Locate.ViewModel)
}

class PatientTagsSearchViewController: UIViewController, PatientTagsSearchDisplayLogic {
    
    var interactor: PatientTagsSearchInteractorProtocol?
    var router: PatientTagsSearchRouterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    private var scanningView: ScanningView?
    private var emptyStateView: EmptyStateView?
    private var beacons: [Beacon] = []
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        interactor?.locateNearbyBeacons(request: PatientTagsSearch.Locate.Request())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.forceStopLocatingBeacons()
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        tableView.registerNib(PatientTagTableViewCell.self)
        
        if let emptyStateView = emptyStateView {
            view.addConstraintsForWrappedInsideView(emptyStateView, respectSafeArea: true)
            emptyStateView.titleLabel.text = "No Patient Tags in Proximity"
        }
        
        if let scanningView = scanningView {
            view.addConstraintsForWrappedInsideView(scanningView)
            scanningView.titleLabel.text = "Scanning for Patient Tags".localized()
            scanningView.subtitleLabel.text = "Get in proximity to the designated devices".localized()
        }
        
        let barButtonItem = UIBarButtonItem(title: "Scan".localized(), style: .plain, target: self, action: #selector(scanButtonAction))
        navigationItem.leftBarButtonItem = barButtonItem
        navigationItem.title = "Assign Tag".localized()
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .subtleGray
        navigationController?.navigationBar.prefersLargeTitles = true
        view.setApplicationGradientBackground()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.bounces = false
    }
    
    //MARK: - Displaying Logic
    
    func displayNearbyTags(viewModel: PatientTagsSearch.Locate.ViewModel) {
        if let scanningView = scanningView, !scanningView.isHidden {
            scanningView.animateFade(positive: false) { [weak self] _ in
                self?.scanningView?.isHidden = true
            }
        }
        
        beacons = viewModel.beacons
        if beacons.count > 0 {
            emptyStateView?.isHidden = true
        } else {
            emptyStateView?.isHidden = false
        }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate

extension PatientTagsSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let beacon = beacons[indexPath.row]
        interactor?.patientTagAssignHandler?.didAssignBeacon(beacon)
    }
}

//MARK: - UITableViewDataSource

extension PatientTagsSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return beacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PatientTagTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let beacon = beacons[indexPath.row]
        
        cell.tagImageView.image = UIImage(named: beacon.representationImageName)
        cell.titleLabel.text = beacon.representationName
        let accuracy = fabs(beacon.accuracy.rounded(toPlaces: 2))
        cell.subtitleLabel.text = "\(accuracy)" + "m away".localized()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

//MARK: - Button Actions
extension PatientTagsSearchViewController {
    
    @objc func scanButtonAction(_ sender: UIBarButtonItem) {
        scanningView?.isHidden = false
        scanningView?.animateFade(positive: true, completition: { [weak self] _ in
            self?.interactor?.locateNearbyBeacons(request: PatientTagsSearch.Locate.Request())
        })
    }
}

//MARK: - Properties Injection

extension PatientTagsSearchViewController {
    func injectProperties(interactor: PatientTagsSearchInteractorProtocol,
                          presenter: PatientTagsSearchPresenterProtocol,
                          router: PatientTagsSearchRouterProtocol,
                          scanningView: ScanningView,
                          emptyStateView: EmptyStateView) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
        
        self.scanningView = scanningView
        self.emptyStateView = emptyStateView
    }
}
