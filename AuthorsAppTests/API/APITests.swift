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
        
        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNil(error, "Get Authors: retrivied an error waiting for expectations")
            XCTAssertNotNil(authorResponse, "Get Authors: the response is nil")
        }
    }
    
    /// Test if the number of authors retrivied are > 0
    func testNumberOfAuthors() {
        
    }
}
