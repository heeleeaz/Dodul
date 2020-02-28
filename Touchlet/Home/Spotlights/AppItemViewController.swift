//
//  HomeItemTableViewCell.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class AppItemViewController: HomeSupportCollectionViewController{
    @objc weak var scrollView: NSScrollView!
    
    private let spotlightRepository = SpotlightRepository.instance
    private var spotlightResult: SpotlightResult?
    
    private var spotlightItem: [SpotlightItem] = []{
        didSet{
            collectionView.reloadData()
            compactSize(ofView: view.superview!, collectionView, append: 60)            
            DispatchQueue.main.async {
                self.scrollView.fitContent()
                
                //scroll to top in first query
                if self.spotlightItem.count == Constant.SPOTLIGHT_PAGING_INITIAL{
                    self.scrollView.scrollToBeginingOfDocument()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        spotlightRepository.callback = { result in
            self.spotlightResult = result
            self.spotlightItem = self.spotlightResult?.next(forward: Constant.SPOTLIGHT_PAGING_INITIAL) ?? []
        }
        spotlightRepository.query()
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
    
    override func itemAtPosition(at index: Int) -> String? {return spotlightItem[index].bundleIdentifier}
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
                self.spotlightItem += self.spotlightResult?.next(forward: Constant.SPOTLIGHT_PAGING_FORWARD) ?? []
            })
            return collectionViewItem
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotlightItem.count + ((spotlightResult?.hasNext ?? false) ? 1 : 0)
    }
}

extension AppItemViewController{
    struct Constant {
         static let SPOTLIGHT_PAGING_INITIAL = 10
         static let SPOTLIGHT_PAGING_FORWARD = 15
     }
}
