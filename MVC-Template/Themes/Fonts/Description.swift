//
//  Description.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class Description: UILabel {
        required init(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)!
                self.commonInit()

            }

            override init(frame: CGRect) {
                super.init(frame: frame)
                self.commonInit()
            }
        
        func commonInit () {
            self.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }

}
