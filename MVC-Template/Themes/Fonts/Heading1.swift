//
//  Heading1.swift
//  MVC-Template
//
//  Created by Nataniel Christandy on 14/06/21.
//

import UIKit

class Heading1: UILabel {
    required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            self.commonInit()

        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            self.commonInit()
        }
    
    func commonInit () {
        self.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
}
