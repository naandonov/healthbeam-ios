//
//  PatientTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class PatientTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet private weak var ageTitleLabel: UILabel!
    @IBOutlet private weak var locationTitleLabel: UILabel!
    @IBOutlet private weak var healthRecordsTitleLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var healthRecordsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ageTitleLabel.text = "Age:".localized()
        locationTitleLabel.text = "Location:".localized()
        healthRecordsTitleLabel.text = "PID:".localized()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
