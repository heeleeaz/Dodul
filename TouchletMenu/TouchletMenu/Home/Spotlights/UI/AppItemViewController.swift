//
//  HomeItemTableViewCell.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

class AppItemViewController: HomeSupportCollectionViewController{
    @objc weak var scrollView: NSScrollView!
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
            collectionView.reloadData()
            compactSize(ofView: view.superview!, collectionView, append: 60)
            
            DispatchQueue.main.async {
                self.scrollView.fitContent()
                           
                //scroll to top in first query
                if self.spotlightItem.count == Constant.SPOTLIGHT_PAGING_INITIAL{self.scrollView.scrollToBeginingOfDocument()}
            }
        }
    }
    
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
    
    override func itemAtPosition(at index: Int) -> TouchBarItem? {
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
            collectionViewItem.showAction(action: .seeMore, {
                self.spotlightItem += self.spotlightRepository.result?.next(forward: Constant.SPOTLIGHT_PAGING_FORWARD) ?? []
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
        spotlightItem = spotlightRepository.result?.next(forward: Constant.SPOTLIGHT_PAGING_INITIAL) ?? []
    }
}

extension AppItemViewController{
    struct Constant {
         static let SPOTLIGHT_PAGING_INITIAL = 10, SPOTLIGHT_PAGING_FORWARD = 15
     }
}
