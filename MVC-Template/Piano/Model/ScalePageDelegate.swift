//
//  ScalePageDelegate.swift
//  MVC-Template
//
//  Created by Nico Christian on 18/06/21.
//

import Foundation

@objc protocol ScalePageDelegate {
    @objc optional func didSelectScale(rootScale: String)
}
