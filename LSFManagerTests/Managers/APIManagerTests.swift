//
//  APIManagerTests.swift
//  LSFManagerTests
//
//  Created by Daniel Montano on 20.12.17.
//  Copyright © 2017 danielmontano. All rights reserved.
//

import XCTest

class APIManagerTests: XCTestCase {
    
    let apiManager = APIManager.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTestAPIKey() {
        
        let wrongApiKey = "34r2h8f9hu304r1wxßs340t34ifbqwd0134234"
        
        let validApiKey = "294u23fob33ßrfiwrhf034hf34hgß34gß223ru"
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
