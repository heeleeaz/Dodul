//
//  OnboardingViewController.swift
//  Meta
//
//  Created by Elias on 05/05/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import AppLib

class OnboardingPageController: NSPageController, NSPageControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.arrangedObjects = [OnboardingApiModel(imageUri: "", description: "Easily drag your apps and web pages to the Touchbar"),
                                OnboardingApiModel(imageUri: "", description: "")]
        self.selectedIndex = 0
    }
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {"\(selectedIndex)"}
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        guard
            let controller = OnboardingPageAdapterVC.createFromStoryboard(),
            let index = Int(identifier),
            let model = arrangedObjects[index] as? OnboardingApiModel else{ return NSViewController() }
        
        controller.onboardingModel = model
        return controller
    }
}

extension OnboardingPageController{
    static func presentAsWindowKeyAndOrderFront(){
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Onboarding"), bundle: Bundle.main)
        if let window = (storyboard.instantiateInitialController() as? NSWindowController){
            window.showWindow(nil)
        }
    }
}
