//
//  PillButton.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//
import UIKit

let padding: CGFloat = 32.0

class PillButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(#colorLiteral(red: 0.6291375756, green: 0.6193236709, blue: 0.7431026101, alpha: 1), for: .normal)
        titleLabel!.font = UIFont.systemFont(ofSize: 12.00, weight: .bold)
        layer.borderWidth = 3.0
        layer.borderColor = #colorLiteral(red: 0.6291375756, green: 0.6193236709, blue: 0.7431026101, alpha: 1)
        layer.cornerRadius = 12.32
        sizeToFit()
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width+padding, height: 25.0)
        addTarget(self, action: #selector(pillButtonPressed(_:)), for: .touchDown)
    }
    @objc func pillButtonPressed(_ sender:UIButton){
        setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .highlighted)
}

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0.6291375756, green: 0.6193236709, blue: 0.7431026101, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}


