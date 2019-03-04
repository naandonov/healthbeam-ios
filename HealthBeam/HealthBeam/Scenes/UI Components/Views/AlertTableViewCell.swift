//
//  AlertTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gatewayLocationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
