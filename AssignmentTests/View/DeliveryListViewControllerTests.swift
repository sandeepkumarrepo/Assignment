//
//  ViewControllerTests.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 13/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import XCTest
import Foundation
@testable import Assignment

class DeliveryListViewControllerTests: XCTestCase {
    
    var deliveryListViewController: DeliveryListViewController = DeliveryListViewController()
    @objc var mockViewModel: DeliveryViewModelSpy!
    
    override func setUp() {        
        // get
        mockViewModel = DeliveryViewModelSpy()
        
        // set
        deliveryListViewController.viewModel = mockViewModel
        
        deliveryListViewController.loadView()
        deliveryListViewController.setupUI()
        deliveryListViewController.addKeyValueObserver()
        XCTAssertNotNil(deliveryListViewController.viewModel)
        XCTAssertNotNil(deliveryListViewController.title)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockViewModel = nil
        super.tearDown()
    }

    func testviewModelAutoUpdation() {
        deliveryListViewController.viewModel.deliveryItems.removeAll()
        let record = DeliveryItemModel()
        record.descriptionText = "Test description"
        deliveryListViewController.viewModel.deliveryItems.append(record)
        
        guard let tableView = deliveryListViewController.listView?.deliveryTableView else {
            return
        }
        XCTAssertEqual(deliveryListViewController.listView?.tableView(tableView, numberOfRowsInSection: 0), 1)
    }
    
    func testRetryMessageWithEmptyRecord() {
        mockViewModel.isFirstTimeRequest = true
        deliveryListViewController.viewModel.deliveryItems.removeAll()
        deliveryListViewController.viewModel.errorMessage = LocalizationConstant.failMessage
        XCTAssertTrue(deliveryListViewController.listView?.deliveryTableView?.isHidden ?? true)
    }
    
    func testDeliveriesUpdatedWithEmptyValue() {
        deliveryListViewController.viewModel.deliveryItems.removeAll()
        deliveryListViewController.deliveriesUpdated()
        XCTAssertTrue(deliveryListViewController.listView?.deliveryTableView?.isHidden ?? true)
    }
    
    func testPullToRefreshWithError() {
        mockViewModel.isErrorResult = true
        mockViewModel.isPullToRefreshRequest = false
        deliveryListViewController.pullToRefresh()
        XCTAssertTrue(mockViewModel.pullToRefreshCalled)
    }
    
    func testPullToRefreshWithSuccess() {
        mockViewModel.isPullToRefreshRequest = true
        deliveryListViewController.pullToRefresh()
        XCTAssertTrue(mockViewModel.pullToRefreshCalled)
    }
    
    func testFetchLoadMoreData() {
        mockViewModel.isLoadMoreRequest = true
        deliveryListViewController.fetchLoadMoreData()
        XCTAssertTrue(mockViewModel.loadMoreCalled)
    }

    func testShowError() {
        deliveryListViewController.showError(message: "Mock error")
        DispatchQueue.main.async {
            XCTAssertNotNil(self.deliveryListViewController.listView?.deliveryTableView?.tableFooterView)
        }
    }
    
    func testShowErrorWithEmptyValues() {
        mockViewModel.deliveryItems = []
        deliveryListViewController.showError(message: "Mock error")
        DispatchQueue.main.async {
            XCTAssertFalse(self.deliveryListViewController.listView?.retryButton.isHidden ?? false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
        }
    }
}
