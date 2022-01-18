//
//  APITests.swift
//  AuthorsAppTests
//
//  Created by Miguel on 18/01/2022.
//

import XCTest
@testable import AuthorsApp

class APITests: XCTestCase {
    
    /*
     Testing the response of the API and the JSON parser used
     */

    override func setUpWithError() throws {
        print("Starting tests")
    }

    override func tearDownWithError() throws {
        print("Tests finished")
    }

    // MARK: - API Tests
    
    /// Test the request to load authors
    func testGetAuthors() {
        
        let authorExpectation = expectation(description: "Get Author Test")
        var authorResponse: [AuthorObject]?
        
        AppRequests.search(author: "tolkien") { items in
            authorResponse = items
            authorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0) { error in
            XCTAssertNil(error, "Get Authors: retrivied an error waiting for expectations")
            XCTAssertNotNil(authorResponse, "Get Authors: the response is nil")
        }
    }
    
    /// Test if the number of authors retrivied are > 0
    func testNumberOfAuthorsWithA() {
        
        let authorExpectation = expectation(description: "Search 'a' string test")
        var authorResponse: [AuthorObject]?
        
        AppRequests.search(author: "a") { items in
            authorResponse = items
            authorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0) { error in
            
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
}
