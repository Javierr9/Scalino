//
//  FullNotesCell.swift
//  MC2
//
//  Created by Nico Christian on 14/06/21.
//

import UIKit

class FullNotesCell: UICollectionViewCell {

    @IBOutlet var noteViews: [UIView]!
    @IBOutlet var noteLabels: [UILabel]!
    @IBOutlet var numericNoteLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeNotesView()
    }
    
    private func initializeNotesView() {
        for noteView in noteViews {
            noteView.layer.borderWidth = 0.5
            noteView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        for note in numericNoteLabels {
            note.textColor = lightPurple
            note.font = UIFont.systemFont(ofSize: 17, weight: .black)
        }
    }
}
