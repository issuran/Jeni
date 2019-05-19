//
//  PillCollectionViewCell.swift
//  Jeni
//
//  Created by Tiago Oliveira on 18/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class PillCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var medicineBackgroundView: JeniMedicineViewButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            medicineBackgroundView.backgroundColor = isSelected ? UIColorUtils.backgroundBlueColor : .clear
            titleLabel.textColor = isSelected ? .white : .darkGray
        }
    }
}
