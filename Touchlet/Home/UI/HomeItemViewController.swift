//
//  _HomeItemViewController.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class HomeItemViewController: NSViewController, NibLoadable{
    @IBOutlet weak var tableView: NSTableView!
    
    private let packageTypes: [CorePackageType] = CorePackageType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(AppItemTableRowView.nib, forIdentifier: AppItemTableRowView.reuseIdentifier)
        tableView.register(BookmarkTableRowView.nib, forIdentifier: BookmarkTableRowView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
    }
    
    //And add the functions of the protocol
    func presentAlert(title:String, message:String){
        //This is the function that'll be called from the cell
        //Here you can personalize how the alert will be displayed

        print("title \(title)")
    }
}

extension HomeItemViewController: NSTableViewDelegate, NSTableViewDataSource{
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        var identifier: NSUserInterfaceItemIdentifier
        switch packageTypes[row] {
        case .App:
            identifier = AppItemTableRowView.reuseIdentifier
        case .Bookmark:
            identifier = BookmarkTableRowView.reuseIdentifier
        }
        return tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableRowView
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int { return packageTypes.count }
}
