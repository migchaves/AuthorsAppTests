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
        XCTAssertTrue(searchBar.exists)
        print("Found search bar")
        
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
    }
}
