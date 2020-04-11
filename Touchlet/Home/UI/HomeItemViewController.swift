//
//  _HomeItemViewController.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import TouchletCore

class HomeItemViewController: NSViewController, NibLoadable, HomeItemViewControllerDelegate{
    @IBOutlet weak var tableView: NSTableView!
    
    private lazy var items = [AppItemViewController.createFromStoryboard()!, BookmarkViewController.createFromStoryboard()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        items.forEach{$0.delegate = self}
    }
    
    func homeItemViewController(collectionItemChanged controller: HomeCollectionViewController) {
        tableView.beginUpdates()
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0
            tableView.noteHeightOfRows(withIndexesChanged: [0, 1])
        }
        tableView.endUpdates()
    }
}

extension HomeItemViewController: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {items.count}
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {items[row].view}

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let item = items[row]
        return item.isViewLoaded ? (item.height ?? 150) : 150
    }
}
