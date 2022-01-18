//
//  AuthorsAppTests.swift
//  AuthorsAppTests
//
//  Created by Miguel on 17/01/2022.
//

import XCTest
@testable import AuthorsApp

class AuthorsAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - API Tests
    
    /// Test the request to load authors
    func testGetAuthors() {
        
        let authorExpectation = expectation(description: "authors")
        var authorResponse: [AuthorObject]?
        
        AppRequests.search(author: "tolkien") { items in
            authorResponse = items
            authorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            XCTAssertNotNil(authorResponse)
        }
    }
}
