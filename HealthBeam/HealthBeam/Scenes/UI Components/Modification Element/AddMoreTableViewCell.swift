//
//  AddMoreTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 31.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class AddMoreTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var addMoreButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
