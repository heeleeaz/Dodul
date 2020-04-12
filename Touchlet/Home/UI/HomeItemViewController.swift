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
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("cell\(row)")
        if let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView{
            return cell
        }else{
            return createView(identifier: identifier, view: items[row].view)
        }
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return items[row].isViewLoaded ? (items[row].height ?? 150) : 150
    }
    
    private func createView(identifier: NSUserInterfaceItemIdentifier, view: NSView) -> NSTableCellView{
        let cell = NSTableCellView()
        cell.identifier = identifier
        cell.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([view.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                                     view.topAnchor.constraint(equalTo: cell.topAnchor),
                                     view.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: cell.bottomAnchor)])
        return cell
    }
}
