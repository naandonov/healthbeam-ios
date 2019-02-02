//
//  NotesTableViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class NotesTableViewCell: ModificationBaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
