//
//  DodulTests.swift
//  DodulTests
//
//  Created by Elias on 05/07/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import XCTest
import AppLib

class GlobalTests: XCTestCase {
    private let global = Global.instance
    
    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testPanelAppName() {
        #if DEBUG
        XCTAssertEqual(global.appName(for: .panel), "DodulPanel (Dev)")
        #else
        XCTAssertEqual(global.appName(for: .menu), "DodulPanel")
        #endif
    }
    
    func testPanelAppBundleIdentifier() {
        #if DEBUG
        XCTAssertEqual(global.bundleIdentifier(for: .panel), "com.heeleeaz.Dodul.Panel.debug")
        #else
        XCTAssertEqual(global.appName(for: .panel), "com.heeleeaz.Dodul.Panel")
        #endif
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
