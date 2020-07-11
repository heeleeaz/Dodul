//
//  ViewController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import AppLib
import Carbon

class MainViewController: EditableTouchBarController {
    @IBOutlet weak var menuPanelContainer: NSView!
    @IBOutlet weak var saveMenuContainer: NSView!
    
    private lazy var saveMenuViewController = SaveMenuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildHelper(MenuPanelViewController.createFromNib()!, view: menuPanelContainer)
        addChildHelper(saveMenuViewController, view: saveMenuContainer)
    }
    
    override func didUpdateTouchbarItemList() {
        if !saveMenuViewController.isSaveButtonEnabled{
            //isTouchDirty loops to compare list under the hood. hence, stick to calling it once
            saveMenuViewController.isSaveButtonEnabled = isTouchbarDirty
        }
    }
    
    override func keyDown(with event: NSEvent) {
        //do nothing to ignore to keystroke sound
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
