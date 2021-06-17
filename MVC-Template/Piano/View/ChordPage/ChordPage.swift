//
//  ChordPage.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class ChordPage: UIView {

    @IBOutlet var Major1Btn : UIButton!
    @IBOutlet var Minor1Btn : UIButton!
    @IBOutlet var Minor2Btn : UIButton!
    @IBOutlet var Major2Btn : UIButton!
    @IBOutlet var Major3Btn : UIButton!
    @IBOutlet var Minor3Btn : UIButton!
    @IBOutlet var DimBtn : UIButton!

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
        bundle.loadNibNamed("CustomView", owner: self, options: nil)
        addSubview(ChordPageView)
        ChordPageView.frame = bounds
        ChordPageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
}
