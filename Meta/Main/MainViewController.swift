//
//  ViewController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore

class MainViewController: EditableTouchBarController {
    override func viewDidAppear() {
        super.viewDidAppear()
        
//        OnboardingPageController.presentAsWindowKeyAndOrderFront()
    }
    
    override func cancelOperation(_ sender: Any?) {
        if isTouchbarDirty{
            let alert = NSAlert()
            alert.messageText = "Save Changes?"
            alert.informativeText = "You've made some changes, they will only reflect if you save them."
            alert.alertStyle = .informational
            
            alert.addButton(withTitle: "Save")
            alert.addButton(withTitle: "Close")
            alert.beginSheetModal(for: view.window!) { ( modalResponse) in
                switch modalResponse{
                case .alertFirstButtonReturn:
                    self.commitChangesAndDispatchUpdateNotification()
                default:
                    NSApp.terminate(nil)
                }
            }
        }else{
            commitChangesAndDispatchUpdateNotification()
        }
    }
    
    private func commitChangesAndDispatchUpdateNotification(){
        commitTouchBarEditing()
        
        DistributedNotificationCenter.default().postNotificationName(.touchItemReload, object: nil, userInfo: nil, options: .deliverImmediately)
        NSApp.terminate(nil)
    }
}

class MainWindow: NSWindow{
    public override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        trackScreenViewEvent(screen: self.className) //track screenView
    }
    
    override var contentView: NSView?{
        didSet{
            if let frame = NSScreen.main?.frame{
                setFrame(frame, display: true)
                setContentSize(frame.size)
            }
        }
    }
}
