//
//  FullNotesCell.swift
//  MC2
//
//  Created by Nico Christian on 14/06/21.
//

import UIKit

let Purple = #colorLiteral(red: 0.337254902, green: 0.3019607843, blue: 0.5019607843, alpha: 1)
let lightPurple = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.7294117647, alpha: 1)

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
            let customGesture = NoteLongPressGesture()
            customGesture.minimumPressDuration = 0.01
            customGesture.notePressed = noteView.tag
            customGesture.noteView = noteView
            customGesture.addTarget(self, action: #selector(pianoNotePressed(_:)))
            noteView.layer.borderWidth = 0.5
            noteView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            noteView.addGestureRecognizer(customGesture)
        }
        for note in numericNoteLabels {
            note.textColor = lightPurple
            note.font = UIFont.systemFont(ofSize: 17, weight: .black)
        }
    }
    
    @objc func pianoNotePressed(_ sender: NoteLongPressGesture) {
        guard let notePressed = sender.notePressed,
              let noteView = sender.noteView
        else { return }
        
        if sender.state == .began {
            // panggil function play sound disini
            noteLabels[notePressed].textColor = .white
            noteView.backgroundColor = Purple
        }
        else if sender.state == .ended {
            sender.noteView?.backgroundColor = PianoModel.blackNotesTag.firstIndex(of: notePressed) != nil ? .black : .white
            noteLabels[notePressed].textColor = PianoModel.blackNotesTag.firstIndex(of: notePressed) != nil ? .white : .black
        }
    }
}
