//
//  HomeItemTableViewCell.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore

class AppItemViewController: HomeCollectionViewController, StoryboardLoadable, SpotlightRepositoryDelegate{
    static var storyboardName: String?{ return "HomeItemViewController"}
        
    @IBOutlet weak var sortButton: NSButton!{
        didSet{
            sortButton.image?.isTemplate = true
            if #available(OSX 10.14, *) {self.sortButton.contentTintColor = DarkTheme.unselectedTintColor}
        }
    }
    
    private let spotlightRepository = SpotlightRepository.instance
    private var listIsSorted = false
        
    private var spotlightItem: [CellItem] = []{
        didSet{
            collectionView.reloadData()
            delegate?.homeCollectionViewController(self, itemHeightChanged: height)
        }
    }
    
    override var height: CGFloat?{return (collectionView.contentSize?.height ?? 0) + 60}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 120, height: 110)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(AppCollectionViewItem.self, forItemWithIdentifier: AppCollectionViewItem.reuseIdentifier)
        collectionView.register(ButtonCollectionViewItem.self, forItemWithIdentifier: ButtonCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        sortButton.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(sortButtonClicked)))
    }
    
    override func viewWillAppearSingleInvocked() {
        spotlightItem = Array(repeating: SpotlightItem.dummy, count: Constant.pagingInitial)
        
        spotlightRepository.delegate = self
        spotlightRepository.query()
    }
    
    func spotlightRepository(spotlightRepository: SpotlightRepository, result: SpotlightResult) {
        spotlightItem = spotlightRepository.result?.next(forward: Constant.pagingInitial) ?? []
        
        if spotlightRepository.result?.hasNext ?? false{spotlightItem.append(ButtonCellItem())}
    }
    
    @objc private func sortButtonClicked(button: NSButton){
        if listIsSorted{
            if let result = spotlightRepository.result{
                result.sortByRecentUsage()

                self.spotlightItem = result.next(forward: result.reset())
                if #available(OSX 10.14, *) {sortButton.contentTintColor = DarkTheme.unselectedTintColor}
            }
        }else{
            if let result = spotlightRepository.result{
                result.sortAlphabetically()

                spotlightItem = result.next(forward: result.reset())
                if #available(OSX 10.14, *) {sortButton.contentTintColor = DarkTheme.selectedTintColor}
            }
        }
        
        listIsSorted.toggle()
    }
    
    override func touchBarItem(at index: Int) -> TouchBarItem? {
        guard let item = spotlightItem[index] as? SpotlightItem else {return nil}
        return TouchBarItem(identifier: item.bundleIdentifier, type: .App)
    }
}

extension AppItemViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cellItem = spotlightItem[indexPath.item]
        if let link = cellItem as? SpotlightItem{
            let view = collectionView.makeItem(withIdentifier: AppCollectionViewItem.reuseIdentifier, for: indexPath)
            guard let collectionViewItem = view as? AppCollectionViewItem else {return view}
            
            collectionViewItem.spotlight = link
            return collectionViewItem
        }else{
            let view = collectionView.makeItem(withIdentifier: ButtonCollectionViewItem.reuseIdentifier, for: indexPath)
            guard let collectionViewItem = view as? ButtonCollectionViewItem else {return view}
            
            collectionViewItem.showAction(action: .seeMoreIcon, {
                let newItems = self.spotlightRepository.result?.next(forward: Constant.pagingForward) ?? []
                
                //insert before the naviation item
                self.spotlightItem.insert(contentsOf: newItems, at: self.spotlightItem.endIndex - 1)
                
                //remove navigation item since there is no more item to fetch
                if self.spotlightRepository.result?.hasNext ?? false == false{self.spotlightItem.removeLast()}
            })
            return collectionViewItem
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {spotlightItem.count}
}

extension AppItemViewController{
    struct Constant {
        fileprivate static let pagingInitial = 15, pagingForward = 25
    }
}
