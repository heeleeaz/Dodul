//
//  TouchBarCollectionItem.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarCollectionViewItem: NSCollectionViewItem{
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("TouchBarCollectionViewItem")
    
    var image: NSImage? {didSet{iconImageView.image = image}}
    
    private lazy var iconImageView: NSImageView = {return NSImageView()}()
        
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()        
    }
    
    private func setupView(){
        view.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([iconImageView.widthAnchor.constraint(equalToConstant: 24),
                                     iconImageView.heightAnchor.constraint(equalToConstant: 24),
                                     iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
}
