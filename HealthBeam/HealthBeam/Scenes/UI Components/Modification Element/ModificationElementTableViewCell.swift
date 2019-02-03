//
//  ModificationElementTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class ModificationElementTableViewCell: ModificationBaseTableViewCell {

    @IBOutlet weak var textField: ModificationStandardTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
//        selectionStyle = .none
    }

    override func prepareForReuse() {
        textField.inputView = nil
        textField.inputAccessoryView = nil
        isHidden = false
        textField.isUserInteractionEnabled = true
        textField.tintColor = tintColor
        textField.canPerformActions = true
    }
    
    override func displayFailedVerification() {
        if let text = textField.attributedPlaceholder {
        textField.attributedPlaceholder = NSAttributedString(string: text.string,
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
    }
    
    override func displayValidInput() {
        if let text = textField.attributedPlaceholder {
            textField.attributedPlaceholder = NSAttributedString(string: text.string,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
}
