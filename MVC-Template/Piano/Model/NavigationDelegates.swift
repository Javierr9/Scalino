//
//  NavigationDelegates.swift
//  MVC-Template
//
//  Created by Nico Christian on 15/06/21.
//

import Foundation

@objc protocol NavigationDelegate {
    @objc optional func navigateToMain()
    @objc optional func navigateToScale()
    @objc optional func navigateToLearn()
    @objc optional func navigateToChord()
    @objc optional func navigateToTestKnowledge()
    
    
    @objc optional func navigateToLearnScale()
    @objc optional func navigateToLearnChord()
    @objc optional func navigateToTestScale()
    @objc optional func navigateToTestChord()
}
