//
//  DataManagerSpy.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 03/05/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation
@testable import Assignment

class DataManagerSpy: DataManagerInterface {
    var isErrorResponse: Bool = false
    var isEmptySuccess: Bool = false
    
    func fetchDeliveries(offSet: Int, limit: Int = Constants.kFetchLimit, completion: @escaping([DeliveryItemModel]?, Error?) -> Void ) {
        if isErrorResponse {
            let error = NSError(domain: "Error", code: -1009, userInfo: [NSLocalizedDescriptionKey: LocalizationConstant.noNetworkMessage])
            completion(nil, error)
            return
        }
        
        if isEmptySuccess {
            completion([], nil )
            return
        }
        
        let mockRecord = self.mockRecord(id: 100)
        completion([mockRecord], nil )
    }
    
    func fetchDeliveriesForPullToRefresh(completion: @escaping([DeliveryItemModel]?, Error?) -> Void) {
        if isErrorResponse {
            let error = NSError(domain: "Error", code: -1009, userInfo: [NSLocalizedDescriptionKey: LocalizationConstant.noNetworkMessage])
            completion(nil, error)
            return
        }
        
        if isEmptySuccess {
            completion([], nil )
            return
        }
        
        let mockRecord = self.mockRecord(id: 100)
        completion([mockRecord], nil )
    }
    
    func deleteLocalData(entity: String) -> Bool {
        return true
    }
    
    func saveDeliveriesInDB(records: [DeliveryItemModel], completion: @escaping(Bool) -> Void) {
        
    }
    
    func mockRecord(id: Int) -> DeliveryItemModel {
        let mockRecord = DeliveryItemModel()
        mockRecord.id = id
        mockRecord.descriptionText = "Mock test descroption"
        mockRecord.imageUrl = "Mock test image url"
        let location = Location()
        location.address = "Mock test address"
        location.lat = 12.9922
        location.lng = 37.19828
        mockRecord.location = location
        return mockRecord
    }
}
