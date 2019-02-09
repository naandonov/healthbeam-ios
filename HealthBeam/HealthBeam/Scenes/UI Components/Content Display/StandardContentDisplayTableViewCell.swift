//
//  StandardContentDisplayTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 8.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class StandardContentDisplayTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = StyleCoordinator.Metrics.subCardViewCornerRadius
        containerView.clipsToBounds = true
        label.textColor = .darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
