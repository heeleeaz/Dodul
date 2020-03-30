//
//  HomeItemTableViewCell.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
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
        
    private var spotlightItem: [SpotlightItem] = Array(repeating: SpotlightItem.dummy, count: Constants.SPOTLIGHT_PAGING_INITIAL){
        didSet{
            collectionView.reloadData()
            
            let lastItem = max(spotlightItem.count - 1, 0)
            collectionView.enclosingScrollView?.scrollToVisible(collectionView.frameForItem(at: lastItem))
            
            delegate?.homeItemViewController(collectionItemChanged: self)
        }
    }
    
    override var height: CGFloat?{return (collectionView.contentSize?.height ?? 0) + 60}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        spotlightRepository.delegate = self
        spotlightRepository.query()
        
        sortButton.addClickGestureRecognizer{
            if self.listIsSorted{
                if let result = self.spotlightRepository.result{
                    let position = result.reset()
                    result.sortByRecentUsage()
                    self.spotlightItem = result.next(forward: position)
                    
                    if #available(OSX 10.14, *) {self.sortButton.contentTintColor = DarkTheme.unselectedTintColor}
                }
            }else{
                if let result = self.spotlightRepository.result{
                    let position = result.reset()
                    result.sortAlphabetically()
                    self.spotlightItem = result.next(forward: position)
                    
                    if #available(OSX 10.14, *) {self.sortButton.contentTintColor = DarkTheme.selectedTintColor}
                }
            }
            
            self.listIsSorted.toggle()
        }
    }
    
    private func setupCollectionView(){
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 120, height: 110)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(AppCollectionViewItem.self, forItemWithIdentifier: AppCollectionViewItem.reuseIdentifier)
        collectionView.register(ButtonCollectionViewItem.self, forItemWithIdentifier: ButtonCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
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
                self.spotlightItem += self.spotlightRepository.result?.next(forward: Constants.SPOTLIGHT_PAGING_FORWARD) ?? []
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
        spotlightItem = spotlightRepository.result?.next(forward: Constants.SPOTLIGHT_PAGING_INITIAL) ?? []
    }
}

extension AppItemViewController{
    struct Constants {
         static let SPOTLIGHT_PAGING_INITIAL = 10, SPOTLIGHT_PAGING_FORWARD = 30
     }
}