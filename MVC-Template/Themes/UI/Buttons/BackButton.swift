//
//  ExampleTableViewCell.swift
//  MVC-Template
//
//  Created by Allicia Viona Sagi on 04/06/21.
//

import UIKit

class backButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
       setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
        tintColor = #colorLiteral(red: 0.6291375756, green: 0.6193236709, blue: 0.7431026101, alpha: 1)
        addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
    }
    @objc func backButtonPressed(_ sender:UIButton){
}

}

// NANDO N IVAN JANLUP SET TYPE BUTTONNYA JADI CUSTOM & STATE CONFIGNYA HIGHLIGHTED @ XIB!
