//
//  DeliveryListViewTests.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 27/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import XCTest
import UIKit
@testable import Assignment

class DeliveryListViewTests: XCTestCase {
    let deliveryListView = DeliveryListView()
    var mockListViewController: DeliveryListViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // get
        mockListViewController = DeliveryListViewController()
        // set
        deliveryListView.controllerDelegate = mockListViewController
        
        XCTAssertNotNil(deliveryListView.deliveryTableView)
        XCTAssertNotNil(deliveryListView.activityIndicator)
        XCTAssertNotNil(deliveryListView.retryButton)
        XCTAssertNotNil(deliveryListView.refreshControlView)
    }

    override func tearDown() {
        mockListViewController = nil
        super.tearDown()
    }
    
    private func mockRecord() -> DeliveryItemModel {
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

    func testTableViewDelegate() {
        XCTAssertTrue(deliveryListView.conforms(to: UITableViewDelegate.self))
    }
    
    func testTableViewDataSource() {
        XCTAssertTrue(deliveryListView.conforms(to: UITableViewDataSource.self))
    }
    
    func testConfigureCell() {
        let testRecord = DeliveryItemModel()
        deliveryListView.controllerDelegate?.viewModel.deliveryItems.append(testRecord)
        let tableView = deliveryListView.deliveryTableView
        let cell = deliveryListView.tableView(tableView!, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell)
    }
    
    func testNumberOfRowsInSection() {
        guard let tableview =  deliveryListView.deliveryTableView else {
            return
        }
        XCTAssertNotNil(deliveryListView.tableView(tableview, numberOfRowsInSection: 0))
    }
    
    func testTableViewMethods() {
        let tableView = deliveryListView.deliveryTableView
        XCTAssertNotNil(deliveryListView.tableView(tableView!, numberOfRowsInSection: 0))
        XCTAssertNotNil(deliveryListView.tableView(tableView!, estimatedHeightForRowAt: IndexPath(row: 0, section: 0)))
    }
    
    func testCellConfigureForOneRecord() {
        let tableView = deliveryListView.deliveryTableView
        deliveryListView.controllerDelegate?.viewModel.deliveryItems.removeAll()
        let testRecord = self.mockRecord()
        deliveryListView.controllerDelegate?.viewModel.deliveryItems.append(testRecord)
        let cell = deliveryListView.tableView(tableView!, cellForRowAt: IndexPath(row: 0, section: 0)) as! CustomTableViewCell
        XCTAssertEqual(cell.descriptionLabel?.text, testRecord.descriptionText)
    }
    
    func testCellConfigureWithEmptyValues() {
        deliveryListView.controllerDelegate?.viewModel.deliveryItems.removeAll()
        let mockRecord = DeliveryItemModel()
        mockRecord.descriptionText = ""
        deliveryListView.controllerDelegate?.viewModel.deliveryItems.append(mockRecord)
        let tableView = deliveryListView.deliveryTableView
        let cell = deliveryListView.tableView(tableView!, cellForRowAt: IndexPath(row: 0, section: 0)) as! CustomTableViewCell
        XCTAssertEqual(cell.descriptionLabel?.text, mockRecord.descriptionText)
    }
    
    func testCellConfigureWithNilValues() {
        deliveryListView.controllerDelegate?.viewModel.deliveryItems.removeAll()
        let mockRecord = DeliveryItemModel()
        mockRecord.descriptionText = nil
        deliveryListView.controllerDelegate?.viewModel.deliveryItems.append(mockRecord)
        let tableView = deliveryListView.deliveryTableView
        let cell = deliveryListView.tableView(tableView!, cellForRowAt: IndexPath(row: 0, section: 0)) as! CustomTableViewCell
        XCTAssertEqual(cell.descriptionLabel?.text, mockRecord.descriptionText)
    }

    func testSetupFooterView() {
        deliveryListView.setupFooter(true)
        XCTAssertNotNil(deliveryListView.deliveryTableView?.tableFooterView)
        
        deliveryListView.setupFooter(false)
        XCTAssertNotNil(deliveryListView.deliveryTableView?.tableFooterView)
    }
    
    func testshowRetryButton() {
        deliveryListView.showRetryButton()
        DispatchQueue.main.async {
            XCTAssertFalse(self.deliveryListView.retryButton.isHidden)
        }
    }
    
    func testPullToRefreshFinished() {
        deliveryListView.pullToRefreshFinished()
         DispatchQueue.main.async {
            XCTAssertFalse(self.deliveryListView.refreshControlView?.isRefreshing ?? false)
        }
    }
    
    func testShowErrorMessage() {
        deliveryListView.showMessage()
        DispatchQueue.main.async {
            XCTAssertNotNil(self.deliveryListView.deliveryTableView?.tableFooterView)
        }
    }
        
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
