//
//  CacheManagerTests.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 23/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import XCTest
@testable import Assignment
import Alamofire

class DataManagerTests: XCTestCase {

    let dataManager = DataManager()
    var mockCoreData: CoreDataManagerSpy!
    var mockAPIManager: APIManagerSpy!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockCoreData = CoreDataManagerSpy()
        mockAPIManager = APIManagerSpy()
        dataManager.coreDataStore = mockCoreData
        dataManager.apiClient = mockAPIManager
    }
    
    private func createTestRecord() -> DeliveryItemModel {
        let testRecord = DeliveryItemModel()
        testRecord.id = 1
        testRecord.descriptionText = "Test description"
        testRecord.imageUrl = "This is sample image url"
        // Location 1
        let location = Location()
        location.address = "This is sample location address"
        location.lat = 22.2200134
        location.lng = 37.9220012
        testRecord.location = location
        return testRecord
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockCoreData = nil
        mockAPIManager = nil
    }

    func testFetchDeliveriesForPullToRefresh() {
        let promise = expectation(description: "expected valid data from the json file")
        mockAPIManager.isErrorResponse = false
        dataManager.fetchDeliveriesForPullToRefresh { (items, error) in
            XCTAssertNotNil(items)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 20) { error in
            if let error = error {
                XCTAssertNotNil(error, "Webservice response returns with error")
            }
        }
    }
    
    func testErrorFetchDeliveriesForPullToRefresh() {
        let promise = expectation(description: "expected in valid data and error from the json file")
        mockAPIManager.isErrorResponse = true
        dataManager.fetchDeliveriesForPullToRefresh { (items, error) in
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 20)
    }
    
    func testSaveRecords() {
        let mockRecord = DeliveryItemModel()
        let previousCount = dataManager.countForEntityInDB(entity: Constants.CoreDataEntity.deliveryItemEntity)
        dataManager.saveDeliveriesInDB(records: [mockRecord]) { [weak self] (done   ) in
            let currentCount = self?.dataManager.countForEntityInDB(entity: Constants.CoreDataEntity.deliveryItemEntity)
            XCTAssertEqual(previousCount+1, currentCount)
        }
    }
    
    func testSuccessFetchDeliveries() {
        let testRecord = self.createTestRecord()
        mockCoreData.addRecords(records: [testRecord]) { (done) in
        }
        mockCoreData.isErrorResult = false
        dataManager.fetchDeliveries(offSet: 0) { (items, error) in
            XCTAssertNotNil(items)
            let receivedRecord = items?[0]
            XCTAssertEqual(receivedRecord?.id, 1)
        }
    }
    
    func testErrorFetchDeliveries() {
        mockCoreData.isErrorResult = true
        dataManager.fetchDeliveries(offSet: 0) { (items, error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testSuccessFetchDeliveriesWithAPI() {
        mockCoreData.storedData.removeAll()
        mockAPIManager.isErrorResponse = false
        mockAPIManager.isEmptyResponse = false
        mockCoreData.isErrorResult = false
        dataManager.fetchDeliveries(offSet: 0) { (items, error) in
            if Utils.isNetworkAvailable() {
                XCTAssertNotNil(items)
                let receivedRecord = items?[0]
                XCTAssertEqual(receivedRecord?.id, 100)
            } else {
                // Error
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testErrorFetchDeliveriesWithAPI() {
        mockCoreData.storedData.removeAll()
        mockAPIManager.isErrorResponse = true
        dataManager.fetchDeliveries(offSet: 0) { (items, error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testDeleteRecords() {
        let isDeleted = dataManager.deleteLocalData(entity: " ")
        XCTAssertTrue(isDeleted)
    }
    
    func testCountForDB() {
        let testRecord = self.createTestRecord()
        mockCoreData.addRecords(records: [testRecord]) { (done) in
        }
        
        let count = dataManager.countForEntityInDB(entity: " ")
        XCTAssertEqual(count, 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
