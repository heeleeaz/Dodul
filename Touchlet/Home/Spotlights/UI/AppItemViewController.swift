//
//  HomeItemTableViewCell.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import TouchletCore

class AppItemViewController: HomeCollectionViewController, StoryboardLoadable{
    static var storyboardName: String?{ return "HomeItemViewController"}
        
    @IBOutlet weak var sortButton: NSButton!{
        didSet{
            sortButton.image?.isTemplate = true
            if #available(OSX 10.14, *) {self.sortButton.contentTintColor = DarkTheme.unselectedTintColor}
        }
    }
    
    private let spotlightRepository = SpotlightRepository.instance
    private var listIsSorted = false
        
    private var spotlightItem: [SpotlightItem] = []{
        didSet{
            removeTrailItem(collectionView) //remove navigate more (>) button
            if (oldValue.count == spotlightItem.count){
                collectionView.reloadData()
            }else{
                insertItems(collectionView, oldCount: oldValue.count, newCount: spotlightItem.count)
            }
            delegate?.homeItemViewController(collectionItemChanged: self)
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
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if self.spotlightItem.isEmpty{
            self.spotlightItem = Array(repeating: SpotlightItem.dummy, count: Constant.pagingInitial)
            self.spotlightRepository.delegate = self
            self.spotlightRepository.query()
        }
    }
    
    @objc private func sortButtonClicked(button: NSButton){
        if listIsSorted{
            if let result = spotlightRepository.result{
                result.sortByRecentUsage()

                self.spotlightItem = result.next(forward: result.reset())
                collectionView.reloadData()
                
                if #available(OSX 10.14, *) {sortButton.contentTintColor = DarkTheme.unselectedTintColor}
            }
        }else{
            if let result = spotlightRepository.result{
                result.sortAlphabetically()

                spotlightItem = result.next(forward: result.reset())
                collectionView.reloadData()
                
                if #available(OSX 10.14, *) {sortButton.contentTintColor = DarkTheme.selectedTintColor}
            }
        }
        
        listIsSorted.toggle()
    }
    
    override func touchBarItem(at index: Int) -> TouchBarItem? {
        return TouchBarItem(identifier: spotlightItem[index].bundleIdentifier, type: .App)
    }
}

extension AppItemViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if(indexPath.item < spotlightItem.count){
            let reuseIdentifer = AppCollectionViewItem.reuseIdentifier
            let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
            guard let collectionViewItem = view as? AppCollectionViewItem else {return view}
            
            collectionViewItem.spotlight = spotlightItem[indexPath.item]
            return collectionViewItem
        }else{
            let reuseIdentifer = ButtonCollectionViewItem.reuseIdentifier
            let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
            guard let collectionViewItem = view as? ButtonCollectionViewItem else {return view}
            
            collectionViewItem.showAction(action: .seeMoreIcon, {
                self.spotlightItem += self.spotlightRepository.result?.next(forward: Constant.pagingForward) ?? []
            })
            return collectionViewItem
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotlightItem.count + ((spotlightRepository.result?.hasNext ?? false) ? 1 : 0)
    }
}

extension AppItemViewController: SpotlightRepositoryDelegate{
    func spotlightRepository(spotlightRepository: SpotlightRepository, result: SpotlightResult) {
        spotlightItem = spotlightRepository.result?.next(forward: Constant.pagingInitial) ?? []
    }
}

extension AppItemViewController{
    struct Constant {
        fileprivate static let pagingInitial = 15, pagingForward = 25
    }
}
