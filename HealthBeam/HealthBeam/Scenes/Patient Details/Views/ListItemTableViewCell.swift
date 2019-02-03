//
//  ListItemTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var containerView: CustomizableView!
    @IBOutlet weak var indicatorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.internalColor = .white
        containerView.cornerRadius = StyleCoordinator.Metrics.subCardViewCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
