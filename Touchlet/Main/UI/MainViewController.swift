//
//  ViewController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSTouchBarDelegate {
    @IBOutlet weak var doneButton: NSButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.addClickGestureRecognizer{ terminateApp(self) }
    }
    
    override func cancelOperation(_ sender: Any?) {
        terminateApp(self)
    }
}
