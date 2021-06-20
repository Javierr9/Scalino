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
    
    @IBAction func buttonsTap(_sender: UIButton){
        
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
        let chordnames = getChordNames(from: "C")
        for index in 0..<7 {
            Buttons[index].titleLabel?.text = chordnames[index]
        }
    }
}
