//
//  ViewController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import LinkPresentation

class MainViewController: TouchBarController2 {
    @IBOutlet weak var doneButton: NSButton!
    @IBOutlet weak var keybindTagView: KeybindTagView!
            
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.addClickGestureRecognizer{ terminateApp(self) }
        updateKeybindPresentationView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClosedNotification), name: NSWindow.willCloseNotification, object: nil)
    }
    
    @objc func windowWillClosedNotification(notification: NSNotification){
        if notification.object is PreferencesWindow{updateKeybindPresentationView()}
    }

    override func cancelOperation(_ sender: Any?) {terminateApp(self)}
//
//    override func mouseDown(with theEvent: NSEvent) {
//        print("left mouse")
//    }
//
//    override func rightMouseDown(with theEvent: NSEvent) {
//        print("right mouse")
//    }
    
    private func updateKeybindPresentationView(){
        keybindTagView.removeAllTags()
        if let keybind = GlobalKeybindPreferencesStore.fetch(){
            for s in keybind.description.split(separator: "-"){
                keybindTagView.addTagItem(String(s), isEditing: false)
            }
        }
    }
    
//    override func touchBarCollectionViewWillAppear(collectionView: NSCollectionView, touchBar: NSTouchBar) {
//        collectionView.frame = NSRect(origin: CGPoint(x: 0, y: 100), size: collectionView.frame.size)
//        collectionView.needsDisplay = true
//        collectionView.needsLayout = true
//        print(collectionView.frame)
////        touchBarContainer.addSubview(collectionView)
////        collectionView.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([collectionView.leadingAnchor.constraint(equalTo: touchBarContainer.leadingAnchor),
////                                     collectionView.topAnchor.constraint(equalTo: touchBarContainer.topAnchor),
////                                     collectionView.trailingAnchor.constraint(equalTo: touchBarContainer.trailingAnchor),
////                                     collectionView.bottomAnchor.constraint(equalTo: touchBarContainer.bottomAnchor)])
//    }
}

class MainWindow: NSWindow{
    override var contentView: NSView?{
        didSet{
            if let frame = NSScreen.main?.frame{
                setFrame(frame, display: true)
                setContentSize(frame.size)
            }
        }
    }
}

class MainWindowController: NSWindowController{}
