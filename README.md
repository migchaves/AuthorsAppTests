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
    /// Test the received name and birthdate
    func testAuthorName() {
        
        let authorExpectation = self.expectation(description: "Test received info")
        var authorResponse: [AuthorObject]?
        
        AppRequests.search(author: "Miguel") { items in
            authorResponse = items
            authorExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("Received info error: \(error)")
                return
            }
            
            guard let strongItems = authorResponse else {
                XCTFail("Items are nil")
                return
            }
            
            XCTAssert(strongItems.count > 0, "Number of items is 0")
            
            for item in strongItems {
                
                guard let name = item.name, let date = item.birth_date else {
                    XCTFail("Item without name or date")
                    return
                }
                
                print("Item: \(name), birthdate: \(date)")
            }
        }
    }
```

4 - Prepare the UI tests

Before the tests, update the AppDelegate to remove the animations, so the tests can run faster

```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set animations to false, to perfom the UI tests
        if CommandLine.arguments.contains("RunningTests") {
            UIView.setAnimationsEnabled(false)
        }
        
        return true
    }
```

After that, prepare the tests setting up the environment:

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

#
# License

Responsive Tools is released under the MIT license.

Copyright 2022 (c) Miguel Chaves

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
