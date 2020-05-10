//
//  OnboardingPageAdapterView.swift
//  Meta
//
//  Created by Elias on 05/05/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore

class OnboardingPageAdapterVC: NSViewController, StoryboardLoadable {
    static var storyboardName: String? = "Onboarding"
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var instructionLabel: NSTextField!
    
    var onboardingModel: OnboardingModel!{
        didSet{
            if isViewLoaded{updateView()}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.animates = true
        
        updateView()
    }
    
    private func updateView(){
        imageView.image = NSImage(named: onboardingModel.imageUri)
        instructionLabel.stringValue = onboardingModel.description
    }
}
