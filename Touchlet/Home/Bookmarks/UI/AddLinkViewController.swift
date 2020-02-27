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
    weak var delegate: AddLinkViewControllerDelegate?

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
        let id = prefillLink?.id ?? UUID().uuidString
        let url = URL(string: urlInputField.stringValue)!
        let title = nameInputField.stringValue.isEmpty ? url.absoluteString : nameInputField.stringValue
        
        self.delegate?.addLinkViewController(self, saveLink: Link(title: title, url: url, id: id))
    }
    
    private func validateURL(_ value: String?){doneButton.isEnabled = value?.isValidURL ?? false}
    
    override func cancelOperation(_ sender: Any?) {self.dismiss(nil)}
}

extension AddLinkViewController: NSTextFieldDelegate{
    func controlTextDidChange(_ obj: Notification) {
        validateURL(((obj.object as? NSTextField)?.stringValue))
    }
}

@objc protocol AddLinkViewControllerDelegate{
    func addLinkViewController(_ controller: AddLinkViewController, deleteLink link: Link?)
    func addLinkViewController(_ controller: AddLinkViewController, saveLink link: Link)
    func addLinkViewController(_ controller: AddLinkViewController, dismiss byUser: Bool)
}
