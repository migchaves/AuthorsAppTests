//
//  DataTests.swift
//  AuthorsAppTests
//
//  Created by Miguel on 18/01/2022.
//

import XCTest
@testable import AuthorsApp

class DataTests: XCTestCase {

    /*
     Testing the consistency of the data retrivied
     */

    override func setUpWithError() throws {
        print("Starting tests")
    }

    override func tearDownWithError() throws {
        print("Tests finished")
    }

    // MARK: - Data Tests

    /// Test if the data retrivied is consistent
    func testAuthorInformation() {
        
        let authorExpectation = self.expectation(description: "Test received info")
        var authorResponse: [AuthorObject]?
        
        AppRequests.search(author: "tolkien") { items in
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
                
                guard let subjects = item.top_subjects else {
                    XCTFail("Item: \(item.name ?? "--") without subjects")
                    return
                }
                
                print("Item: \(item.name ?? "--") with \(subjects.count) subjects")
            }
        }
    }
}
