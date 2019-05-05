//
//  DeliveryViewModelTests.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 17/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import XCTest
@testable import Assignment
import CoreData

class DeliveryListViewModelTests: XCTestCase {
    let deliveryViewModel = DeliveryListViewModel()
    var mockDataManager: DataManagerSpy!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockDataManager = DataManagerSpy()
        deliveryViewModel.dataManager = mockDataManager
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        deliveryViewModel.deliveryItems = []
        mockDataManager = nil
    }
    
    func testDeliveriesWithSuccess() {
        deliveryViewModel.getData()
        XCTAssertEqual(deliveryViewModel.deliveryItems.count, 1)
    }
    
    func testEmptyDeliveries() {
        mockDataManager.isEmptySuccess = true
        deliveryViewModel.getData()
        XCTAssertNotNil(deliveryViewModel.errorMessage)
    }
    
    func testDeliveriesWithError() {
        mockDataManager.isErrorResponse = true
        deliveryViewModel.getData()
        XCTAssertFalse(deliveryViewModel.isFirstTimeRequest)
    }
    
    func testPullToRefreshWithError() {
        mockDataManager.isErrorResponse = true
        deliveryViewModel.fetchDeliveriesWithPullToRefresh { (done, error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testPullToRefreshWithEmptyResponse() {
        let count = deliveryViewModel.deliveryItems.count
        mockDataManager.isEmptySuccess = true
        deliveryViewModel.fetchDeliveriesWithPullToRefresh { (done, error) in
            XCTAssertEqual(count, self.deliveryViewModel.deliveryItems.count)
        }
    }
    
    func testPullToRefreshWithSuccess() {
        deliveryViewModel.fetchDeliveriesWithPullToRefresh { (done, error) in
            if Utils.isNetworkAvailable() {
                XCTAssertTrue(done)
                return
            }
            XCTAssertFalse(done)
        }
    }
    
    func testPullToRefreshWithInProgressRequest() {
        deliveryViewModel.isLoadMoreRequest = true
        deliveryViewModel.fetchDeliveriesWithPullToRefresh { (done, error) in
            XCTAssertFalse(done)
        }
    }
    
    func testLoadMoreData() {
        let dummyRecord = DeliveryItemModel()
        deliveryViewModel.deliveryItems.append(dummyRecord)
        deliveryViewModel.isLoadMoreRequest = true
        deliveryViewModel.loadMoreData()
        XCTAssertTrue(deliveryViewModel.isLoadMoreRequest)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
