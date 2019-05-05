//
//  CoreDataManagerTests.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 16/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import XCTest
@testable import Assignment
import  CoreData

let kCoreDataEntity = "DeliveryItem"

class CoreDataManagerTests: XCTestCase {
    
    let coreDataManager = CoreDataManager()
    var testRecords: [DeliveryItemModel] = []
    var mockStoreCoordinator: NSPersistentStoreCoordinator!
    var mockManagedObjectContext: NSManagedObjectContext!
    var mockManagedObjectModel: NSManagedObjectModel!
    var mockStore: NSPersistentStore!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // test records
        mockManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        mockStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mockManagedObjectModel)
        mockStore = try? mockStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        mockManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        mockManagedObjectContext.persistentStoreCoordinator = mockStoreCoordinator
        coreDataManager.managedContext = mockManagedObjectContext
        
        testRecords.append(self.createTestRecord())
        testRecords.append(self.createTestRecord())
        testRecords.append(self.createTestRecord())
        testRecords.append(self.createTestRecord())
        testRecords.append(self.createTestRecord())
    }
    
    private func createTestRecord() -> DeliveryItemModel {
        let testRecord = DeliveryItemModel()
        testRecord.id = 0
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

    private func createEmptyTestRecord() -> DeliveryItemModel {
        return DeliveryItemModel()
    }
    
    private func createNilTestRecord() -> DeliveryItemModel {
        let testRecord = DeliveryItemModel()
        testRecord.id = 0
        testRecord.descriptionText = nil
        testRecord.imageUrl = nil
        // Location 1
        let location = Location()
        location.address = nil
        location.lat = -11.00
        location.lng = 0
        testRecord.location = location
        return testRecord
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockManagedObjectContext = nil
        testRecords = []
        mockStore.willRemove(from: mockStoreCoordinator)
        super.tearDown()
    }
    
    func testAddRecords() {
        for record in testRecords {
            coreDataManager.addRecord(record: record)
        }
        XCTAssertEqual(self.testRecords.count, self.coreDataManager.countForEntity(entiry: kCoreDataEntity))
    }
        
    func testFetchDataWithLimitAndOffset() {
        // Adding 21 record
        let testRecord = self.createTestRecord()
        let count = Constants.kFetchLimit + 1
        for _ in 0 ... count {
            coreDataManager.addRecord(record: testRecord)
        }
        
        // Now fetch first 20 record and check with count
        var offset = 0
        var (records, _) = coreDataManager.fetchRecords(offSet: offset, limit: Constants.kFetchLimit)
        XCTAssertEqual(Constants.kFetchLimit, records?.count)
        
        // Now Increament the index
        offset = Constants.kFetchLimit
        (records, _) = coreDataManager.fetchRecords(offSet: offset, limit: Constants.kFetchLimit)
        XCTAssertEqual(1, records?.count)
    }
    
    func testAddRecordWithEmptyValues() {
        let mockRecord = self.createEmptyTestRecord()
        coreDataManager.addRecord(record: mockRecord)
        XCTAssertEqual(1, self.coreDataManager.countForEntity(entiry: kCoreDataEntity))
    }
        
    func testAddRecordWithNilValues() {
        let mockRecord = self.createNilTestRecord()
        coreDataManager.addRecord(record: mockRecord)
        XCTAssertEqual(1, self.coreDataManager.countForEntity(entiry: kCoreDataEntity))
    }
        
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let testRecord = self.createTestRecord()
            for _ in 0 ... 100 {
                coreDataManager.addRecord(record: testRecord)
            }
        }
    }

}
