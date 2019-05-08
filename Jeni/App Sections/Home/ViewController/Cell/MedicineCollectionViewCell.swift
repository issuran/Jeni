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
    @IBOutlet weak var backgroudView: JeniMedicineViewButton!
    
    override var isSelected: Bool {
        didSet {
            self.backgroudView.backgroundColor = isSelected ? UIColorUtils.backgroundBlueColor : UIColor.clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
