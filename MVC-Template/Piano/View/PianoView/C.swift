//
//  C.swift
//  MC2
//
//  Created by Nico Christian on 17/06/21.
//

import UIKit

class C: UICollectionViewCell {

    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var numericNoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeNote()
    }
    
    private func initializeNote() {
        noteView.layer.borderWidth = 0.5
        noteView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        numericNoteLabel.textColor = lightPurple
        numericNoteLabel.font = UIFont.systemFont(ofSize: 17, weight: .black)
    }
}
