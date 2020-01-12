//
//  AddBookmarkViewController.swift
//  Touchlet
//
//  Created by Elias on 12/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class AddLinkViewController: NSViewController, NibLoadable {
    @IBOutlet weak var nameInputField: NSTextField!
    @IBOutlet weak var URLInputField: NSTextField!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var doneButton: NSButton!
    
    var prefillLink: Link?
    var delegate: AddLinkViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.addClickGestureRecognizer{
            self.delegate?.addLinkViewController(self, dismiss: true)
        }
        
        removeButton.addClickGestureRecognizer{
            self.delegate?.addLinkViewController(self, deleteLink: self.prefillLink)
        }
        
        doneButton.addClickGestureRecognizer{
            let title = self.nameInputField.stringValue
            let url = URL.init(string: self.URLInputField.stringValue)
            self.delegate?.addLinkViewController(self, saveLink: Link(title: title, url: url!))
        }
    }
}

protocol AddLinkViewControllerDelegate: class{
    func addLinkViewController(_ controller: AddLinkViewController, deleteLink link: Link?)
    func addLinkViewController(_ controller: AddLinkViewController, saveLink link: Link)
    func addLinkViewController(_ controller: AddLinkViewController, dismiss byUser: Bool)
}
