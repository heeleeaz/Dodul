//
//  ViewController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSTouchBarDelegate {    
    @IBOutlet weak var doneButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.addClickGestureRecognizer{ NSApplication.shared.terminate(self) }
//        h(view: self.view)
        
    }
    
    private func h(view: NSView){
        view.wantsLayer = true
        view.layerUsesCoreImageFilters = true
        view.layer?.backgroundColor = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5).cgColor

        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setDefaults()
        blurFilter?.setValue(2.5, forKey: kCIInputRadiusKey)
        view.layer?.backgroundFilters?.append(blurFilter!)
    }
}


//    let tab = [NSTouchBarItem.Identifier("hello")]
    
    
    
    

    
    //        let slp = SwiftLinkPreview()
    //        slp.preview("http://www.google.com", onSuccess: {print($0)}, onError: {print($0)})
    //
    //        let slp = SwiftLinkPreview(session: URLSession = URLSession.shared,
    //        workQueue: DispatchQueue = SwiftLinkPreview.defaultWorkQueue,
    //        responseQueue: DispatchQueue = DispatchQueue.main,
    //            cache: Cache = DisabledCache.instance)

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
