//
//  DeliveryViewModelSpy.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 04/05/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation
@testable import Assignment

@objc class DeliveryViewModelSpy: NSObject, DeliveryListViewModelInterface {
    @objc dynamic var isFirstTimeRequest: Bool = false
    @objc dynamic var isLoadMoreRequest: Bool = false
    @objc dynamic var isPullToRefreshRequest: Bool = false 
    var errorMessage: String?
    var deliveryListController: DeliveryListViewController?
    var isRequestInProgress: Bool = false
    @objc dynamic var deliveryItems: [DeliveryItemModel] = []
    var isErrorResult: Bool = false
    var pullToRefreshCalled: Bool = false
    var loadMoreCalled: Bool = false
    
    func populateData() {
        
    }
    
    func loadMoreData() {
        loadMoreCalled = true
    }
    
    func fetchDeliveriesWithPullToRefresh(completion: @escaping (Bool, Error?) -> Void) {
        pullToRefreshCalled = true
        if isErrorResult {
            let error = NSError(domain: "ERROR", code: 400, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
            completion(false, error)
            return
        }
        
        completion(true, nil)
    }
    
}
