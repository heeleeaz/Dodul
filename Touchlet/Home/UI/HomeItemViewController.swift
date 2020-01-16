//
//  _HomeItemViewController.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class HomeItemViewController: NSViewController, HomeItemViewControllerDelegate{
    @IBOutlet weak var scrollView: NSScrollView!
    private let packageTypes: [CorePackageType] = CorePackageType.allCases
    
    func resizeControllerView(controller: NSViewController, size: CGSize?) {
        if let size = size{
            controller.view.superview?.heightConstaint?.constant = size.height
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controller = segue.destinationController as? NSViewController{
            controller.view.needsLayout = true
            
            unbind(NSBindingName(rawValue: #keyPath(scrollView))) // unbind first
            bind(NSBindingName(rawValue: #keyPath(scrollView)), to: controller, withKeyPath: #keyPath(scrollView), options: nil)
        }
    }
    
    deinit {
        unbind(NSBindingName(rawValue: #keyPath(scrollView)))
    }
}

protocol HomeItemViewControllerDelegate: class{
    func resizeControllerView(controller: NSViewController, size: CGSize?)
}
