//
//  MenuCollectionViewCell.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 20.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell, NibLoadableView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var innerContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
