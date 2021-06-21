//
//  ChordPageDelegate.swift
//  MVC-Template
//
//  Created by Nico Christian on 18/06/21.
//

import Foundation

@objc protocol ChordPageDelegate {
    @objc optional func didSelectChord(chord: String, nthChord: Int, selectedScale: String)
}
