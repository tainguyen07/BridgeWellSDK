//
//  BridgewellSDKTests.swift
//  BridgewellSDKTests
//
//  Created by Tai Nguyen on 07/01/2024.
//

import XCTest
@testable import BridgewellSDK

final class BridgewellSDKTests: XCTestCase {
    
    var sdk: BridgeWellSDK!
    
    override func setUp() {
        super.setUp()
        sdk = BridgeWellSDK.shared
    }
    
    override func tearDown() {
        sdk = nil
        super.tearDown()
    }
    
    func testGetAllPosts() {
        let expectation = XCTestExpectation(description: "Get all posts")
        
        sdk.getAllPosts { result in
            switch result {
            case .success(let posts):
                XCTAssertFalse(posts.isEmpty, "Posts should not be empty")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get all posts with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetPostByIds() {
        let expectation = XCTestExpectation(description: "Get posts by IDs")
        
        sdk.getPostByIds(ids: [1, 2, 3]) { result in
            switch result {
            case .success(let posts):
                XCTAssertFalse(posts.isEmpty, "Posts should not be empty")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get posts by IDs with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetPostWithCommentByIds() {
        let expectation = XCTestExpectation(description: "Get posts with comments by IDs")
        
        sdk.getPostWithCommentByIds(ids: [1, 2, 3]) { result in
            switch result {
            case .success(let posts):
                XCTAssertFalse(posts.isEmpty, "Posts should not be empty")
                for post in posts {
                    XCTAssertNotNil(post.comments, "Comments should not be nil")
                }
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get posts with comments by IDs with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 10.0) // Increase timeout if needed
    }
    
}
