//
//  _HomeItemViewController.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class HomeItemViewController: NSViewController, HomeItemViewControllerDelegate{
    private let packageTypes: [CorePackageType] = CorePackageType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func resizeControllerView(controller: NSViewController, size: CGSize?) {
        if let size = size{
            controller.view.superview?.heightConstaint?.constant = size.height
        }
        (parent as? MainViewControllerDelegate)?.fitScrollViewContent()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controller = segue.destinationController as? NSViewController{
            controller.view.needsLayout = true
        }
    }
}

protocol HomeItemViewControllerDelegate: class{
    func resizeControllerView(controller: NSViewController, size: CGSize?)
}
