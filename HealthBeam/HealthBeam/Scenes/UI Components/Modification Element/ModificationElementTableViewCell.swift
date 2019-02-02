//
//  ModificationElementTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class ModificationElementTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
//        selectionStyle = .none
    }

    override func prepareForReuse() {
        textField.inputView = nil
        textField.inputAccessoryView = nil
        isHidden = false
    }
}
