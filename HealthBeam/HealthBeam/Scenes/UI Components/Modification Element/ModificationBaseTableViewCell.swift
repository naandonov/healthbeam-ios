//
//  ModificationBaseTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 2.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class ModificationBaseTableViewCell: UITableViewCell, NibLoadableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func displayValidInput() {
    }
    
    func displayFailedVerification() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
