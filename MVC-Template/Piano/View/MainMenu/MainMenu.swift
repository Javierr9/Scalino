//
//  MainMenu.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class MainMenu: UIView {
    
    public weak var delegate: NavigationDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        titleLabel.text = "SCALINO"
        titleLabel.textColor = #colorLiteral(red: 0.4171671867, green: 0.3886381686, blue: 0.5856596231, alpha: 1)
        descTitleLabel.text = "Practice your chords through scales"
        descTitleLabel.textColor = #colorLiteral(red: 0.6819174886, green: 0.6852018833, blue: 0.7779753208, alpha: 1)
        
        testMyScalesButton.setTitle("Test my scales", for: .normal)
        learnButton.setTitle("Let’s Learn", for: .normal)
        testMyChordsButton.setTitle("Test my chords", for: .normal)
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTitleLabel: UILabel!
    @IBOutlet weak var testMyScalesButton: UIButton!
    @IBOutlet weak var learnButton: UIButton!
    @IBOutlet weak var testMyChordsButton: UIButton!
    
    @IBAction func testMyScalesButtonPressed(_ sender: Any) {
        delegate?.navigateToTestScale?()
    }
    
    @IBAction func learnButtonPressed(_ sender: UIButton) {
        delegate?.navigateToLearnScale?()
    }
    
    @IBAction func testMyChordsButtonPressed(_ sender: UIButton) {
        delegate?.navigateToTestChord?()
    }
}
