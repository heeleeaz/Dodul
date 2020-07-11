//
//  AppCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import AppLib

class AppCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("AppCollectionViewItem")
    
    var spotlight: SpotlightItem!{didSet{if isViewLoaded { updateView()}}}
    
    private lazy var appIconImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyDown
        
        return imageView
    }()
    
    private lazy var appNameTextField: NSTextField = {
        let textField = NSTextField()
        textField.font = NSFont.systemFont(ofSize: 13)
        textField.textColor = DarkTheme.textColor
        textField.isEditable = false
        textField.isSelectable = false
        textField.drawsBackground = false
        textField.isBezeled = false
        textField.alignment = .center
        textField.maximumNumberOfLines = 1
        textField.lineBreakMode = .byTruncatingTail
        
        return textField
    }()
    
    private lazy var viewContainer: NSView = {
        let view = NSView()
        view.cornerRadius = 7
        view._backgroundColor = Theme.touchBarButtonBackgroundColor
        return view
    }()
    
    override func loadView() {
        super.view = NSView()
        view.addSubview(viewContainer)
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([viewContainer.topAnchor.constraint(equalTo: view.topAnchor),
                                     viewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     viewContainer.widthAnchor.constraint(equalToConstant: 90),
                                     viewContainer.heightAnchor.constraint(equalToConstant: 40)])
        
        //icon image
        viewContainer.addSubview(appIconImageView)
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([appIconImageView.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
                                     appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     appIconImageView.widthAnchor.constraint(equalToConstant: 26),
                                     appIconImageView.heightAnchor.constraint(equalToConstant: 26)])
        
        //app name
        view.addSubview(appNameTextField)
        appNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([appNameTextField.topAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 5),
                                     appNameTextField.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
                                     appNameTextField.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
                                     appNameTextField.heightAnchor.constraint(equalToConstant: 16)])
    }
    
    private func updateView(){
        appNameTextField.stringValue = spotlight.displayName ?? ""
        appIconImageView.image = SpotlightRepository.findAppIcon(bundleIdentifier: spotlight.bundleIdentifier) ?? NSImage(named: "DefaultAppIcon")
    }
    
    override var draggingImageComponents: [NSDraggingImageComponent]{
        appNameTextField.isHidden = true
        defer{
            appNameTextField.isHidden = false
        }
        return super.draggingImageComponents
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fromColor = Theme.touchBarButtonBackgroundColor.highlight(withLevel: 0.1)
        let toColor = Theme.touchBarButtonBackgroundColor
        ViewAnimation.backgroundFlashAnimation(view.subviews[0], from: fromColor, to: toColor)
    }
}
