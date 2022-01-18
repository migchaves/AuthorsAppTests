//
//  APITests.swift
//  AuthorsAppTests
//
//  Created by Miguel on 18/01/2022.
//

import XCTest
@testable import AuthorsApp

class APITests: XCTestCase {
    
    private let timeOutInterval: TimeInterval = 10.0
    
    /*
     Testing the response of the API and the JSON parser used
     */

    override func setUpWithError() throws {
        print("Starting tests")
        self.continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        print("Tests finished")
    }

    // MARK: - API Tests
    
    /// Test the request to load authors
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
    
    /// Test if the number of authors retrivied are > 0
    func testNumberOfAuthorsWithA() throws {
        
        let authorExpectation = self.expectation(description: "Search 'a' string test")
        var authorResponse: [AuthorObject]?
        
        AppRequests.search(author: "Miguel") { items in
            authorResponse = items
            authorExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: self.timeOutInterval) { error in
            
            if let error = error {
                XCTFail("Search 'a' string test error: \(error)")
                return
            }
            
            guard let items = authorResponse else {
                XCTFail("Search 'a' string test error: response is nil")
                return
            }
            
            XCTAssert(items.count > 0, "Get authors: response without items")
        }
    }
    
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
}
