//
//  RoundCell.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class RoundCell: UICollectionViewCell {
    @IBOutlet weak var roundCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 29.5
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = #colorLiteral(red: 0.6274509804, green: 0.6196078431, blue: 0.7411764706, alpha: 1)
        let selectedView = UIView (frame: bounds)
        selectedView.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6196078431, blue: 0.7411764706, alpha: 1)
        selectedView.layer.cornerRadius = 29.5
        self.selectedBackgroundView = selectedView
        
    }

}
