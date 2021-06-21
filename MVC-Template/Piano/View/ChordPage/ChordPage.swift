//
//  ChordPage.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class ChordPage: UIView {

    @IBOutlet var Title: UILabel!
    @IBOutlet var Buttons: [UIButton]!
    var selectedScale = ""
    public weak var chordPageDelegate: ChordPageDelegate?
    
    @IBAction func buttonsTap(_ sender: UIButton){
        guard let selectedChord = sender.titleLabel?.text
        else { return }
        chordPageDelegate?.didSelectChord?(chord: selectedChord, nthChord: sender.tag, selectedScale: selectedScale)
    }

    @IBOutlet weak var ChordPageView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("ChordPage", owner: self, options: nil)
        addSubview(ChordPageView)
        ChordPageView.frame = bounds
        ChordPageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        Title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        Title.textColor = Purple
    }
    public func configureButtonLabels(chordNames: [String]) {
        for index in 0 ..< 7 {
            Buttons[index].setTitle(chordNames[index], for: .normal)
        }
    }
    public func configureTitleLabel(rootNote: String) {
        selectedScale = rootNote
        Title.text = "CHORDS IN \(rootNote) MAJOR"
    }
}
