//
//  CustomToggle.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class NotationToggle: UISwitch {
    override func awakeFromNib() {
        super.awakeFromNib()
      isOn = true
        tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        onTintColor = #colorLiteral(red: 0.6291375756, green: 0.6193236709, blue: 0.7431026101, alpha: 1)
        addTarget(self, action: #selector(toggleSwitched(_:)), for: .valueChanged)

      
    }
    @objc func toggleSwitched(_ sender:UISwitch){
}
    
    
}


// SWITCHNYA MASIH NUNGGU USER DEFAULT!!!
