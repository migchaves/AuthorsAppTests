# AuthorsAppTests
Demo project to implement multiple Unit Tests and UI Tests.

The App is quite simple: 
- A single controller with a UISearchBar and a UITableView to display the results;
- Allows to search for authors in a public and free API (Example: https://openlibrary.org/search/authors.json?q=tolkien);
- Implementation of multiple tests;

Using this API to retrieve data, there are some tests to measure the time response, the data and consistency of the information.

# Still implementing some UI tests

1 - Testing the load of data from API

Example: retrieving data and check if it's working

```swift
    func testGetAuthors() throws {
        
        let authorExpectation = self.expectation(description: "Get Author Test")
        var authorResponse: [AuthorObject]?
        
        AppRequests.search(author: "Miguel") { items in
            authorResponse = items
            authorExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: self.timeOutInterval) { error in
            XCTAssertNil(error, "Get Authors: retrivied an error waiting for expectations")
            XCTAssertNotNil(authorResponse, "Get Authors: the response is nil")
        }
    }
```

2 - Measure the time the request takes

```swift
    /// Measure the time spent in the request
    func testRequestTimeMeasure() throws {
        
        self.measure {
            
            let authorExpectation = self.expectation(description: "Measure time test")
            
            AppRequests.search(author: "Miguel") { items in
                authorExpectation.fulfill()
            }
            
            self.waitForExpectations(timeout: self.timeOutInterval) { error in
                
                if let error = error {
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }
        }
    }
```

3 - Checking the consistency of the data

```swift
    func testGetAuthors() throws {
        
        let authorExpectation = self.expectation(description: "Get Author Test")
        var authorResponse: [AuthorObject]?
        
        AppRequests.search(author: "Miguel") { items in
            authorResponse = items
            authorExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: self.timeOutInterval) { error in
            XCTAssertNil(error, "Get Authors: retrivied an error waiting for expectations")
            XCTAssertNotNil(authorResponse, "Get Authors: the response is nil")
        }
    }
```

4 - Prepare the UI tests

```swift
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
```

5 - UITest: load data to the tableview and check if the tableview get visible.

For this case the flow is:
- App is lunched
- Tap on search bar and enter string to search
- Wait for the results to be loaded
- Check if the table view appears with some rows

```swift
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
```
