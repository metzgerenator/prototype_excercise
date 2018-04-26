//
//  freezaUITests.swift
//  freezaUITests
//
//  Created by Michael Metzger  on 4/25/18.
//  Copyright © 2018 Zerously. All rights reserved.
//

import XCTest

class freezaUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveAndLoad() {
        
        let tablesQuery = app.tables
        let navbar = app.navigationBars["freeza.TopEntriesView"]
        let favoriteButton = navbar/*@START_MENU_TOKEN@*/.buttons["Favorites"]/*[[".staticTexts.buttons[\"Favorites\"]",".buttons[\"Favorites\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        favoriteButton.tap()
        
        let moreButton = tablesQuery.buttons["More..."]
        moreButton.tap()
        
    }
    
    
    func testLoadMore() {
        
        let tablesQuery = app.tables
        let moreButton = tablesQuery.buttons["More..."]
        moreButton.tap()
        let numberOfCells = tablesQuery.cells.count
        XCTAssert(numberOfCells > 2, "call did not work")
        
        
        
    }
    
    
    

}
