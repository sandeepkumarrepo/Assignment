//
//  DetailViewControllerTests.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 17/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import XCTest
@testable import Assignment
import MapKit
import CoreData

class DetailViewControllerTests: XCTestCase {
    
    let detailViewController = DetailViewController()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        detailViewController.loadView()
        detailViewController.viewModel.model = self.createTestRecord()
        detailViewController.viewDidLoad()
        
        XCTAssertNotNil(detailViewController)
        XCTAssertNotNil(detailViewController.viewModel)
        XCTAssertNotNil(detailViewController.detailView)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func createTestRecord() -> DeliveryItemModel {
        let testRecord = DeliveryItemModel()
        testRecord.id = 0
        testRecord.descriptionText = "Test description"
        testRecord.imageUrl = "This is sample image url"
        let location = Location()
        location.address = "This is sample location address"
        location.lat = 22.2200134
        location.lng = 37.9220012
        
        return testRecord
    }
    
    func testMethods() {
        detailViewController.addAnnotation(title: "Test", lattitude: 22.9987, longitude: 123.299)
        XCTAssertNotNil(detailViewController.detailView.pinAnnotation)
        
        detailViewController.showPin(lat: 22.2929, long: 122.0088, address: "Address")
        XCTAssertNotNil(detailViewController.detailView.pinAnnotation)
        
        detailViewController.refreshUI(description: "Test", imageUrl: "ImageUrl")
        XCTAssertNotNil(detailViewController.detailView.pinAnnotation)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
