//
//  SaveSelectorViewController.swift
//  Meta
//
//  Created by Elias on 09/05/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore
import UserNotifications

class SaveMenuViewController: NSViewController {
    
    private lazy var editableTouchBarController: EditableTouchBarController = {
        guard let controller = self.parent as? EditableTouchBarController else {
            fatalError("parent must be an instance of EditableTouchBarItem")
        }
        return controller
    }()
    
    var isSaveButtonEnabled: Bool{
        set{
            (view.subviews.last as? NSButton)?.isEnabled = newValue
        }
        get{
            return (view.subviews.last as? NSButton)?.isEnabled ?? false
        }
    }
    
    override func loadView() {
        self.view = NSView()
        view.wantsLayer = true
        view.layer?.cornerRadius = 10
        view.layer?.backgroundColor = DarkTheme.quickLaunchPreferenceContainerBackgroundColor.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCloseAndSaveView()
    }
        
    private func setupCloseAndSaveView(){
        //setup close button
        let closeButton = createButton(title: "Quit",
                                       icon: NSImage(named: "CloseIcon")!, action: #selector(didClickClose))
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                                     closeButton.widthAnchor.constraint(equalToConstant: closeButton.intrinsicContentSize.width+10),
                                     closeButton.heightAnchor.constraint(equalTo: view.heightAnchor)])

        
        //setup vertical line as divider
        let verticalLine = NSView()
        verticalLine._backgroundColor = DarkTheme.borderColor
        view.addSubview(verticalLine)
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([verticalLine.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 10),
                                     verticalLine.topAnchor.constraint(equalTo: view.topAnchor),
                                     verticalLine.widthAnchor.constraint(equalToConstant: 1),
                                     verticalLine.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        
        //setup save button
        let saveButton = createButton(title: "Save and Quit",
                                      icon: NSImage(named: "CheckIcon")!, action: #selector(didClickSaveButton))
        saveButton.isEnabled = false
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([saveButton.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: 10),
                                     saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     saveButton.heightAnchor.constraint(equalTo: view.heightAnchor)])
    }
    
    private func createButton(title: String, icon: NSImage, action: Selector) -> NSButton{
        let button = NSButton(title: title, image: icon.resize(destSize: CGSize(width: 14, height: 14)), target: self, action: action)
        button.font = NSFont.systemFont(ofSize: 16)
        button.isBordered = false
        button.imageHugsTitle = true
        button.alignment = .center
        
        
        if #available(OSX 10.14, *) {
            button.contentTintColor = DarkTheme.buttonTextColor
        } else {
            let attribute = [NSAttributedString.Key.foregroundColor: DarkTheme.buttonTextColor!]
            button.attributedTitle = NSAttributedString(string: title, attributes: attribute)
        }
        return button
    }
    
    private func showHotkeyTooltipNotification(terminateApp: Bool){
        DistributedNotificationCenter.default().postNotificationName(.touchItemReload, object: nil, userInfo: nil, options: .deliverImmediately)
        
        if let keyArray = GlobalKeybindPreferencesStore.fetch()?.toArray{
            let content = SupportNotificationManager.Content()
            content.id = Constant.hotkeyTooltipNotification
            content.title = "Magic with \(keyArray.joined(separator: ""))"
            content.message = "Press \(keyArray.joined(separator: "")) to show and open the items from the Touchbar."
            content.actionString = "Got it!"
            content.timeInterval = 2
            SupportNotificationManager.shedule(content){ _ in
                if terminateApp{DispatchQueue.main.async {NSApp.terminate(nil)}}
            }
        }
    }
    
    @objc private func didClickSaveButton(button: NSButton){
        editableTouchBarController.commitTouchBarEditing()
        
        showHotkeyTooltipNotification(terminateApp: true)
    }
 
    @objc private func didClickClose(button: NSButton){showHotkeyTooltipNotification(terminateApp: true)}
}
