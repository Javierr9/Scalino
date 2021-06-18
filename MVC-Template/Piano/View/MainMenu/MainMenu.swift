//
//  MainMenu.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class MainMenu: UIView {
    
    public weak var delegate: NavigationDelegate?
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("MainMenu", owner: self, options: nil)
        titleLabel.text = "SCALINO"
        titleLabel.textColor = #colorLiteral(red: 0.4171671867, green: 0.3886381686, blue: 0.5856596231, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        descTitleLabel.text = "Practice your chords through scales"
        descTitleLabel.textColor = #colorLiteral(red: 0.6819174886, green: 0.6852018833, blue: 0.7779753208, alpha: 1)
        descTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        testMyScalesButton.setTitle("Test my scales", for: .normal)
        learnButton.setTitle("Let’s Learn", for: .normal)
        testMyChordsButton.setTitle("Test my chords", for: .normal)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
