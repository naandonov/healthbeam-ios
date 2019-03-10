//
//  AlertDescriptionViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 6.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol AlertDescriptionViewInput: class {
    var output: AlertDescriptionViewOutput? { get set }
    
    var dataSource: [AlertRespondNavigation.DescriptionModel] { get set }
}

class AlertDescriptionViewController: UIViewController, AlertDescriptionViewInput {
    @IBOutlet weak var tableView: UITableView!
    
    weak var output: AlertDescriptionViewOutput?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var respondButton: UIButton!
    @IBOutlet weak var actionContainerView: OutlineView!
    
    var dataSource: [AlertRespondNavigation.DescriptionModel] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Patient Alert".localized()

        tableView.registerNib(PatientTagTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.bounces = false
        tableView.backgroundColor = .subtleGray
        
        actionContainerView.strokeColor = .subtleGray
        
        descriptionLabel.text = "The patient requires immediate medical assistance!".localized()
        respondButton.setTitle("Respond".localized(), for: .normal)
    }
    
    @IBAction func respondButtonAction(_ sender: Any) {
        output?.didPressRespondButton()
    }
    
}

extension AlertDescriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row]
        return model.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PatientTagTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let model = dataSource[indexPath.row]
        cell.tagImageView.image = UIImage(named: model.imageName)
        cell.titleLabel.text = model.title
        cell.titleLabel.textColor = model.titleColor
        cell.subtitleLabel.text = model.subtitle
        cell.selectionStyle = .none
        
        return cell
    }
}

extension AlertDescriptionViewController: UITableViewDelegate {
    
}
