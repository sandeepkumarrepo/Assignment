//
//  APIManagerTests.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 14/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import XCTest
@testable import Assignment

let host = "mock-api-mobile.dev.lalamove.com"

class APIManagerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testValidDeliveryData() {
        XCStub.request(withPathRegex: host, withResponseFile: "MockData.json")
        let promise = expectation(description: "expected data from the json file")
        let urlStr = Constants.kBaseUrl + Endpoint.deliveries.rawValue
        var params: [String: Any] = ["offset": 0]
        params["limit"] = Constants.kFetchLimit

        APIManager().requestWithURL(urlStr: urlStr, params: params) { result in
            
            switch result {
            case .success(let deliveries):
                XCTAssertNotNil(deliveries)
                promise.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 20) { error in
            if let error = error {
                XCTAssertNotNil(error, "Webservice response returns with error")
            }
        }
    }
    
    func testInValidDeliveryData() {
        XCStub.request(withPathRegex: host, withResponseFile: "MockData_Invalid.json")
        let promise = expectation(description: "expected error as file does not exists")
        var params: [String: Any] = ["offset": 0]
        params["limit"] = Constants.kFetchLimit

        APIManager().requestWithURL(urlStr: "", params: params) { result in
            
            switch result {
            case .success(let deliveries):
                print(deliveries)
            case .failure(let error):
                print(error.localizedDescription)
                promise.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTAssertNotNil(error, "Webservice response returns with error")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
