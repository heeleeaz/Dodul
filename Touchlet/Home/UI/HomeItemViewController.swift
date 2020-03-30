//
//  _HomeItemViewController.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

class HomeItemViewController: NSViewController, NibLoadable, HomeItemViewControllerDelegate{
    func appItemViewController(itemUpdated: [SpotlightItem], viewHeight: Int) {
        tableView.noteHeightOfRows(withIndexesChanged: [])
    }
    
    @IBOutlet weak var tableView: NSTableView!
    
    private lazy var items = [AppItemViewController.createFromStoryboard()!, BookmarkViewController.createFromStoryboard()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        items.forEach{$0.delegate = self}
    }
    
    func homeItemViewController(collectionItemChanged controller: HomeCollectionViewController) {
        tableView.noteHeightOfRows(withIndexesChanged: [0, 1])
    }
}

extension HomeItemViewController: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return items[row].view
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let item = items[row]
        return item.isViewLoaded ? (item.height ?? 150) : 150
        
    }
}
