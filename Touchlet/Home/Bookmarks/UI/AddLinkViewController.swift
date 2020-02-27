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
    @IBOutlet weak var urlInputField: NSTextField!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var doneButton: NSButton!
    
    var prefillLink: Link?
    var delegate: AddLinkViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let prefillLink = prefillLink{
            nameInputField.stringValue = prefillLink.title ?? ""
            urlInputField.stringValue = prefillLink.url.absoluteString
            removeButton.isHidden = false
        }else{removeButton.isHidden = true}
    
        validateURL(urlInputField.stringValue)
        urlInputField.delegate = self
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.addLinkViewController(self, dismiss: true)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        self.delegate?.addLinkViewController(self, deleteLink: self.prefillLink)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        let url = self.urlInputField.stringValue
        let title = self.nameInputField.stringValue.isEmpty ? url : self.nameInputField.stringValue
        self.delegate?.addLinkViewController(self, saveLink: Link(title: title, url: URL(string: url)!))
    }
    
    private func validateURL(_ value: String?){doneButton.isEnabled = value?.isValidURL ?? false}
    
    override func cancelOperation(_ sender: Any?) {self.dismiss(nil)}
}

extension AddLinkViewController: NSTextFieldDelegate{
    func controlTextDidChange(_ obj: Notification) {
        validateURL(((obj.object as? NSTextField)?.stringValue))
    }
}

protocol AddLinkViewControllerDelegate: class{
    func addLinkViewController(_ controller: AddLinkViewController, deleteLink link: Link?)
    func addLinkViewController(_ controller: AddLinkViewController, saveLink link: Link)
    func addLinkViewController(_ controller: AddLinkViewController, dismiss byUser: Bool)
}
