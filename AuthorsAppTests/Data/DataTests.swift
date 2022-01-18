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
        self.continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        print("Tests finished")
    }

    // MARK: - Data Tests
    
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

    /// Test the received top subjects for each result
    func testAuthorTopSubjects() {
        
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
                
                guard let subjects = item.top_subjects else {
                    XCTFail("Item: \(item.name ?? "--") without subjects")
                    return
                }
                
                print("Item: \(item.name ?? "--") with \(subjects.count) subjects")
            }
        }
    }
}
