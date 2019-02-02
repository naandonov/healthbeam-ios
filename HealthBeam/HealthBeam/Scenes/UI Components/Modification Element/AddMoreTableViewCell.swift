//
//  AddMoreTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 31.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class AddMoreTableViewCell: ModificationBaseTableViewCell {

    @IBOutlet weak var addMoreButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
