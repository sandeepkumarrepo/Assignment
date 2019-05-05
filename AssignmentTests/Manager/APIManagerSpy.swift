//
//  APIManagerSpy.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 03/05/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation
@testable import Assignment
import Alamofire

class APIManagerSpy: APIManagerInterface {
    var isErrorResponse: Bool = false
    var isEmptyResponse: Bool = false
    
    func requestWithURL(urlStr: String, params: [String: Any], httpMethod: HTTPMethod = HTTPMethod(rawValue: "GET")!, completion: @escaping (Result<[DeliveryItemModel], Error>) -> Void) {
        
        if isErrorResponse {// error mock
            let error = NSError(domain: "Mock Error", code: 404, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        if isEmptyResponse {// empty response
            completion(.success([]))
            return
        }
        
        let mockRecord = self.mockRecord(id: 100)
        completion(.success([mockRecord]))
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
