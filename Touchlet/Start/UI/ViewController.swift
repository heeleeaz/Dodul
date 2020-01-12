//
//  ViewController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTouchBarDelegate {
    let tab = [NSTouchBarItem.Identifier("hello")]
    
    private lazy var homeItemViewController = {
        return HomeItemViewController.createFromNib(in: Bundle.main)!
    }()
    
    override func viewDidAppear() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildHelper(homeItemViewController)
        
        
        
        
//        let slp = SwiftLinkPreview()
//        slp.preview("http://www.google.com", onSuccess: {print($0)}, onError: {print($0)})
//
//        let slp = SwiftLinkPreview(session: URLSession = URLSession.shared,
//        workQueue: DispatchQueue = SwiftLinkPreview.defaultWorkQueue,
//        responseQueue: DispatchQueue = DispatchQueue.main,
//            cache: Cache = DisabledCache.instance)
    }
    
//    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
//        return TextTab(identifier: identifier)
//    }
//
//    override func makeTouchBar() -> NSTouchBar? {
//        let touchBar = NSTouchBar()
//        touchBar.delegate = self
//
//        touchBar.defaultItemIdentifiers = tab
//        touchBar.templateItems = [TextTab(identifier: tab[0])]
//        return touchBar
//    }

}

