//
//  NibLoadable.swift
//  project4
//
//  Created by Elias on 13/12/2019.
//  Copyright © 2019 Elias Igbalajobi. All rights reserved.
//

import Cocoa

protocol NibLoadable {
    static var nibName: String? { get }
    static var nib: NSNib? { get }
    static func createFromNib(in bundle: Bundle) -> Self?
}

protocol StoryboardLoadable {
    static var storyboardName: String? { get }
    static var objectIdentifier: String? { get }
    static func createFromStoryboard(in bundle: Bundle) -> Self?
}

extension NibLoadable where Self: NSView {
    static var nibName: String? {return String(describing: Self.self)}
    
    static var nib: NSNib? {
        guard let nibName = nibName else {return nil}
        return NSNib(nibNamed: NSNib.Name(nibName), bundle: Bundle.main)
    }
    
    static func createFromNib(in bundle: Bundle = Bundle.main) -> Self? {
        guard let nibName = nibName else { return nil }
        var topLevelArray: NSArray?
        bundle.loadNibNamed(NSNib.Name(nibName), owner: self, topLevelObjects: &topLevelArray)
        guard let results = topLevelArray else { return nil }
        let views = [Any](results).filter { $0 is Self }
        return views.last as? Self
    }
}

extension NibLoadable where Self: NSViewController{
    static var nibName: String? {return String(describing: Self.self)}
    
    static var nib: NSNib? {
        guard let nibName = nibName else {return nil}
        return NSNib(nibNamed: NSNib.Name(nibName), bundle: Bundle.main)
    }
    
    static func createFromNib(in bundle: Bundle = Bundle.main) -> Self? {
        return Self(nibName: NSNib.Name(nibName!), bundle: bundle)
    }
}

extension StoryboardLoadable{
    static var storyboardName: String? { return String(describing: Self.self)}
    static var objectIdentifier: String? { return String(describing: Self.self)}

    static func createFromStoryboard(in bundle: Bundle = Bundle.main) -> Self? {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(storyboardName!), bundle: bundle)
        return storyboard.instantiateController(withIdentifier: objectIdentifier!) as? Self
    }
}
