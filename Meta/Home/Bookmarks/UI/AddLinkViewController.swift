//
//  AddBookmarkViewController.swift
//  Touchlet
//
//  Created by Elias on 12/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore

class AddLinkViewController: NSViewController, NibLoadable {
    @IBOutlet weak var nameInputField: NSTextField!
    @IBOutlet weak var urlInputField: NSTextField!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var doneButton: NSButton!
    @IBOutlet weak var invalidURLTextField: NSTextField!
    
    var prefillLink: Link?
    weak var delegate: AddLinkViewControllerDelegate?

    private var bookmarkRepository = BookmarkRepository.instance
    
    private var eventMonitor: ((NSEvent) -> NSEvent?)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let prefillLink = prefillLink{
            nameInputField.stringValue = prefillLink.title ?? ""
            urlInputField.stringValue = prefillLink.url
            removeButton.isHidden = false
        }else{
            removeButton.isHidden = true
        }
    
        urlInputField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(notification:)),
                                               name: NSWindow.willCloseNotification, object: nil)
        
        
        eventMonitor = {if $0.window != self.view.window{self.view.window?.close()}; return $0}
        NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .leftMouseDragged], handler: eventMonitor!)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        nameInputField.becomeFirstResponder()
    }
    
    @objc private func windowWillClose(notification: NSNotification){
        if (notification.object as? NSWindow) == view.window && eventMonitor != nil {
            //TODO: NSEvent.removeMonitor(eventMonitor);
            eventMonitor = nil
        }
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.addLinkViewController(self, bookmarkRepository: bookmarkRepository, dismiss: true)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        if let link = prefillLink {
            bookmarkRepository.delete(link: link)
            delegate?.addLinkViewController(self, bookmarkRepository: bookmarkRepository, delete: link)
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if urlInputField.stringValue.isValidURL{
            let id = prefillLink?.id ?? UUID().uuidString
        
            var url = URL(string: urlInputField.stringValue)!
            if url.scheme?.count ?? 0 == 0{
                url = URL(string: "http://\(urlInputField.stringValue)")!
            }
            
            let title = nameInputField.stringValue.isEmpty ? url.absoluteString : nameInputField.stringValue
            let link = Link(title: title, url: url.absoluteString, id: id)
            
            bookmarkRepository.update(link: link)
            if let oldLink = prefillLink, bookmarkRepository.contains(link: oldLink){
                self.delegate?.addLinkViewController(self, bookmarkRepository: bookmarkRepository, update: link)
            }else{
                self.delegate?.addLinkViewController(self, bookmarkRepository: bookmarkRepository, save: link)
            }
            
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

protocol AddLinkViewControllerDelegate: AnyObject{
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, delete link: Link)
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, update link: Link)
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, save link: Link)
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, dismiss byUser: Bool)
}
