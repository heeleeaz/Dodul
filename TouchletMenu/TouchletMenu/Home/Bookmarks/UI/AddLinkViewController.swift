//
//  AddBookmarkViewController.swift
//  Touchlet
//
//  Created by Elias on 12/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

class AddLinkViewController: NSViewController, NibLoadable {
    @IBOutlet weak var nameInputField: NSTextField!
    @IBOutlet weak var urlInputField: NSTextField!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var doneButton: NSButton!
    @IBOutlet weak var invalidURLTextField: NSTextField!
    
    var prefillLink: Link?
    weak var delegate: AddLinkViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let prefillLink = prefillLink{
            nameInputField.stringValue = prefillLink.title ?? ""
            urlInputField.stringValue = prefillLink.url.absoluteString
            removeButton.isHidden = false
        }else{removeButton.isHidden = true}
    
        urlInputField.delegate = self
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.addLinkViewController(self, dismiss: true)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        self.delegate?.addLinkViewController(self, deleteLink: self.prefillLink)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if urlInputField.stringValue.isValidURL{
            let id = prefillLink?.id ?? UUID().uuidString
        
            var url = URL(string: urlInputField.stringValue)!
            if url.scheme?.count ?? 0 == 0{
                url = URL(string: "http://\(urlInputField.stringValue)")!
            }
            
            let title = nameInputField.stringValue.isEmpty ? urlInputField.stringValue : nameInputField.stringValue
            
            self.delegate?.addLinkViewController(self, saveLink: Link(title: title, url: url, id: id))
        }else{
            invalidURLTextField.isHidden = false
            doneButton.isEnabled = false
        }
    }
    
    override func cancelOperation(_ sender: Any?) {self.dismiss(nil)}
}

extension AddLinkViewController: NSTextFieldDelegate{
    func controlTextDidChange(_ obj: Notification) {
        if (obj.object as? NSTextField) == nameInputField{
            doneButton.isEnabled = !urlInputField.stringValue.isEmpty
            invalidURLTextField.isHidden = true
        }
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline){doneAction(self); return true}
        return false
    }
}

@objc protocol AddLinkViewControllerDelegate{
    func addLinkViewController(_ controller: AddLinkViewController, deleteLink link: Link?)
    func addLinkViewController(_ controller: AddLinkViewController, saveLink link: Link)
    func addLinkViewController(_ controller: AddLinkViewController, dismiss byUser: Bool)
}
