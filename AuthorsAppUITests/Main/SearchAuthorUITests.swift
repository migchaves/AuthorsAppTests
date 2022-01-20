//
//  SearchAuthorUITests.swift
//  AuthorsAppUITests
//
//  Created by Miguel on 18/01/2022.
//

import XCTest
@testable import AuthorsApp

class SearchAuthorUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    // Used to confirm that the table was loaded and has results
    private var tableDataLoaded = false
    
    // MARK: - Prepare for testing

    override func setUpWithError() throws {
        
        print("Starting UI Tests")
        continueAfterFailure = false

        // Launch the App
        self.app = XCUIApplication()
        
        // Add this argument to avoid animations
        self.app.launchArguments = ["RunningTests"]
        self.app.launch()
    }

    override func tearDownWithError() throws {
        print("Finished UI Tests")
    }
    
    // MARK: - Test the search bar
    
    /// Test the input text of the search bar
    func testSearchBar() throws {
                
        // Check if search bar exists
        let searchBar = self.app.otherElements[AccessibilityIdentifiers.Home.searchBar]
        XCTAssertTrue(searchBar.exists, "Home SearchBar not found")
        print("Found Search Bar")
        
        // Check if tableview exists and has 0 cells and is hidden
        let tableview = self.app.tables[AccessibilityIdentifiers.Home.tableView]
        XCTAssert(tableview.cells.count == 0, "Number of cell in empty table is not 0")
        XCTAssert(tableview.isHittable == false, "Table view is not hidden")
        
        // Check if the keyboard appears
        searchBar.tap()
        XCTAssert(self.app.keyboards.count > 0, "The keyboard is not shown")
        
        // Insert some text
        searchBar.typeText("Miguel")
        
        if self.app.keyboards.buttons["buscar"].exists {
            self.app.keyboards.buttons["buscar"].tap()
        }
        
        // Check if the keyboard hides
        XCTAssert(self.app.keyboards.count == 0, "The keyboard was not dismissed")
        
        // Wait the tableview to reload
        guard tableview.waitForExistence(timeout: 10) else {
            XCTFail("Tableview didn't appear after search")
            return
        }
        
        // Check if there are results
        XCTAssertTrue(tableview.exists, "Home TableView not found")
        print("Found Table View")
        
        XCTAssert(tableview.cells.count > 0, "Results not found and not displayed in tableview")
        self.tableDataLoaded = true
    }
    
    /// Test the table tap and push controller
    func testTableTap() {
        
        // Check if the app is running
        if !self.tableDataLoaded {
            do {
                try self.testSearchBar()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        
        // Check if tableview exists
        let tableview = self.app.tables[AccessibilityIdentifiers.Home.tableView]
        XCTAssertTrue(tableview.exists, "Home Table view not found")
        XCTAssert(tableview.cells.count > 0, "Table without results")
        
        // Get the text in the first cell
        let labels = tableview.staticTexts.matching(
            identifier:AccessibilityIdentifiers.Home.tableCellTitleLabel)
        
        XCTAssert(labels.count > 0, "Don't found any label")
        
        let textLabel = labels.element(boundBy: 0)
        XCTAssertTrue(textLabel.exists, "Text Label not found")
        
        let authorName = textLabel.title
        XCTAssertNotNil(authorName, "Author name is nil")
        
        // Tap the first item
        tableview.cells.element(boundBy: 0).tap()
    }
}
