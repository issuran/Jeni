//
//  MedicineCollectionViewCell.swift
//  Jeni
//
//  Created by Tiago Oliveira on 07/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class MedicineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var medicineImageView: UIImageView!    
    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var medicineQtdPerDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
