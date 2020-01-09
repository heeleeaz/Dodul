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
    
    private let allPackages = CorePackageType.allCases
    private let corePackageStore = MockCorePackageStore.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HomeItemTableRowView.nib, forIdentifier: HomeItemTableRowView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
    }
}

extension HomeItemViewController: NSTableViewDelegate, NSTableViewDataSource{
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let package = allPackages[row]
    
        let view = tableView.makeView(withIdentifier: HomeItemTableRowView.reuseIdentifier, owner: self)
        guard let tableViewItem = view as? HomeItemTableRowView else {return nil}
        corePackageStore.findAll(with: package, result: {tableViewItem.corePackageItems = $0})
        
        return tableViewItem
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int { return allPackages.count }
}
