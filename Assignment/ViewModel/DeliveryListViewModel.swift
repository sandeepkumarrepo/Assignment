//
//  DeliveryViewModel.swift
//  Assignment
//
//  Created by Sandeep Kumar on 12/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit
import Reachability

let ERROR = "ERROR"

@objc protocol DeliveryListViewModelInterface: class {
    func populateData()
    func loadMoreData()
    func fetchDeliveriesWithPullToRefresh(completion: @escaping (Bool, Error?) -> Void)
    @objc var deliveryItems: [DeliveryItemModel] { get set }
    @objc dynamic var isFirstTimeRequest: Bool { get set }
    @objc dynamic var isLoadMoreRequest: Bool { get set }
    @objc dynamic var isPullToRefreshRequest: Bool { get set }
    @objc dynamic var errorMessage: String? { get set }
}

@objc class DeliveryListViewModel: NSObject, DeliveryListViewModelInterface {
    
    // Variables
    var dataManager: DataManagerInterface = DataManager()
    private var retryCount = 0
    @objc dynamic var errorMessage: String?
    @objc dynamic var isFirstTimeRequest = false
    @objc dynamic var isLoadMoreRequest = false
    @objc dynamic var isPullToRefreshRequest = false
    @objc dynamic var deliveryItems: [DeliveryItemModel] = []
    
    // MARK: Methods
    func populateData() {
        DispatchQueue.global(qos: .background).async {
            self.getData()
        }
    }
    
    func loadMoreData() {
        if self.deliveryItems.isEmpty {
            // No need to load more
            return
        }
        // While data is fetched from server. Ignore the load data request
        if self.isFirstTimeRequest == true ||
            self.isLoadMoreRequest == true ||
            self.isPullToRefreshRequest == true {
            print("Ignoring load more request")
            return
        }
        
        self.isLoadMoreRequest = true
        self.populateData()
    }
    
    // MARK: Data fetch
    func getData() {
        if self.deliveryItems.isEmpty {
            self.isFirstTimeRequest = true
        }
        
        let offset = self.deliveryItems.count
        self.fetchData(offSet: offset, limit: Constants.kFetchLimit)
    }
    
    private func fetchData(offSet: Int, limit: Int = Constants.kFetchLimit) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        dataManager.fetchDeliveries(offSet: offSet, limit: Constants.kFetchLimit) { [weak self] (items, error) in
            self?.processData(items: items, error: error)
        }
    }
    
    private func processData(items: [DeliveryItemModel]?, error: Error?) {
        guard error == nil else {
            // If no netwrok then do not call again
            if Utils.isNetworkAvailable() == false {
                self.isLoadMoreRequest = false
                self.isFirstTimeRequest = false
                errorMessage = LocalizationConstant.noNetworkMessage
                self.retryCount = 0
                return
            }
            
            self.retryAgain()
            return
        }
        
        if items != nil {
            self.deliveryItems.append(contentsOf: items!)
        }
        
        if items?.isEmpty ?? true {
            errorMessage = LocalizationConstant.failMessage
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        // reset the flags
        self.retryCount = 0
        self.isLoadMoreRequest = false
        self.isFirstTimeRequest = false
    }
}

// MARK: Pull to refresh
extension DeliveryListViewModel {
    func fetchDeliveriesWithPullToRefresh(completion: @escaping (Bool, Error?) -> Void) {
        // If request already in progress then ignore
        if self.isPullToRefreshRequest == true || self.isLoadMoreRequest == true || self.isFirstTimeRequest == true {
            let error = NSError.errorWithMessage(message: LocalizationConstant.requestAlreadyInProgress)
            errorMessage = error.localizedDescription
            completion(false, error)
            return
        }
        
        if Utils.isNetworkAvailable() == false {
            // No network
            let error = NSError.errorWithMessage(message: LocalizationConstant.noNetworkMessage)
            errorMessage = error.localizedDescription
            completion(false, error)
            return
        }
        
        self.isPullToRefreshRequest = true
        dataManager.fetchDeliveriesForPullToRefresh { [weak self] (deliveries, error) in
            self?.isPullToRefreshRequest = false
            guard let _ = deliveries else {
                self?.errorMessage = error?.localizedDescription
                completion(false, error)
                return
            }
            
            // Checking count
            guard deliveries?.count ?? 0 > 0  else {
                completion(true, nil)
                return
            }
            
            self?.deliveryItems = deliveries ?? []
            completion(true, nil)
            
            // Delete all local data and add latest
            if  let _ = self?.dataManager.deleteLocalData(entity: Constants.CoreDataEntity.deliveryItemEntity) {
                // Data deleted successfully
                self?.dataManager.saveDeliveriesInDB(records: deliveries!, completion: { (done) in
                })
            }
        }
    }
}

// MARK: Retry
extension DeliveryListViewModel {
    func retryAgain() {
        if retryCount >= Constants.Retry.kMaxCount {
            // reset the flag
            self.isLoadMoreRequest = false
            self.isFirstTimeRequest = false
            errorMessage = LocalizationConstant.failMessage
            return
        }
        
        retryCount += 1
        // try again
        self.getData()
    }
}

// MARK: Error
extension NSError {
    static func errorWithMessage(message: String) -> NSError {
        return NSError(domain: ERROR, code: 404, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
