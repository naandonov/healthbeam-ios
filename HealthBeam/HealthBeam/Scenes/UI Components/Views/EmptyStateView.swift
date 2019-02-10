//
//  EmptyStateView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 10.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .subtleGray
    }

}
