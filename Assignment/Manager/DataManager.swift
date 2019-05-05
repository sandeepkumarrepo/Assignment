//
//  CacheManager.swift
//  Assignment
//
//  Created by Sandeep Kumar on 23/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation
import Reachability
import Alamofire

protocol DataManagerInterface {
    func fetchDeliveries(offSet: Int, limit: Int, completion: @escaping([DeliveryItemModel]?, Error?) -> Void)
    func fetchDeliveriesForPullToRefresh(completion: @escaping([DeliveryItemModel]?, Error?) -> Void)
    func deleteLocalData(entity: String) -> Bool
    func saveDeliveriesInDB(records: [DeliveryItemModel], completion: @escaping(Bool) -> Void)
}

class DataManager: DataManagerInterface {
    
    var coreDataStore: CoreDataManagerInterface = CoreDataManager()
    var apiClient: APIManagerInterface = APIManager()
    
    // private
    private func deliveryQueryParameter(offset: Int, limit: Int = Constants.kFetchLimit) -> [String: Any] {
        var params: [String: Any] = ["offset": offset]
        params["limit"] = limit
        return params
    }
    
    private func convertModel(coreDataModel: DeliveryItem) -> DeliveryItemModel {
        let convertedModel = DeliveryItemModel()
        convertedModel.id = Int(coreDataModel.id)
        convertedModel.descriptionText = coreDataModel.descriptionText
        convertedModel.imageUrl = coreDataModel.imageUrl
        // Location
        let location = Location()
        location.address = coreDataModel.address
        location.lat = coreDataModel.lat
        location.lng = coreDataModel.lng
        convertedModel.location = location
        return convertedModel
    }
    
    // MARK: Methods
    func fetchDeliveries(offSet: Int, limit: Int = Constants.kFetchLimit, completion: @escaping([DeliveryItemModel]?, Error?) -> Void ) {
        let (items, error) = coreDataStore.fetchRecords(offSet: offSet, limit: limit)
        guard error == nil else {
            var newItems = [DeliveryItemModel]()
            for model in items ?? [] {
                let conModel = self.convertModel(coreDataModel: model)
                newItems.append(conModel)
            }
            
            completion(newItems, error)
            return
        }
        
        if items?.isEmpty ?? true {
            if Utils.isNetworkAvailable() == false {
                let error = NSError(domain: "Error", code: -1009, userInfo: [NSLocalizedDescriptionKey: LocalizationConstant.noNetworkMessage])
                completion(nil, error)
                return
            }
            
            let urlStr = Constants.kBaseUrl + Endpoint.deliveries.rawValue
            let params = self.deliveryQueryParameter(offset: offSet, limit: limit)
            let httpMethod = HTTPMethod(rawValue: "GET")!
            apiClient.requestWithURL(urlStr: urlStr, params: params, httpMethod: httpMethod) { [weak self] result in
                switch result {
                case .success(let deliveries):
                    completion(deliveries, nil)
                    // Save the data in DB
                    self?.saveDeliveriesInDB(records: deliveries, completion: { (done) in
                    })
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }
        } else {
            var newItems = [DeliveryItemModel]()
            for model in items ?? [] {
                let conModel = self.convertModel(coreDataModel: model)
                newItems.append(conModel)
            }
            
            return completion(newItems, error)
        }
    }
    
    func fetchDeliveriesForPullToRefresh(completion: @escaping([DeliveryItemModel]?, Error?) -> Void) {
        let urlStr = Constants.kBaseUrl + Endpoint.deliveries.rawValue
        let params = self.deliveryQueryParameter(offset: 0, limit: Constants.kFetchLimit)
        let httpMethod = HTTPMethod(rawValue: "GET")!
        apiClient.requestWithURL(urlStr: urlStr, params: params, httpMethod: httpMethod) { (result) in
            switch result {
            case .success(let deliveries):
                completion(deliveries, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func deleteLocalData(entity: String) -> Bool {
        return coreDataStore.deleteAllData(entity: entity)
    }
    
    func saveDeliveriesInDB(records: [DeliveryItemModel], completion: @escaping(Bool) -> Void) {
        coreDataStore.addRecords(records: records) { (done) in
            completion(done)
        }
    }
    
    func countForEntityInDB(entity: String) -> Int {
        return coreDataStore.countForEntity(entiry: entity)
    }
}
