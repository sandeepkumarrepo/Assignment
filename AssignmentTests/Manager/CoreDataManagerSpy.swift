//
//  CoreDataManagerSpy.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 03/05/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation
@testable import Assignment
import UIKit

class CoreDataManagerSpy: CoreDataManagerInterface {
    
    var storedData: [DeliveryItem] = []
    var isErrorResult: Bool = false
    var isLocalDataDeletionError: Bool = false
    
    func fetchRecords(offSet: Int, limit: Int) -> ([DeliveryItem]?, Error?) {
        if isErrorResult {
            let error = NSError(domain: "Mock Error", code: 404, userInfo: nil)
            return (nil, error)
        }
        return (storedData, nil)
    }
    
    func deleteAllData(entity: String) -> Bool {
        if isLocalDataDeletionError {
            return false
        }
        storedData.removeAll()
        return true
    }
    
    func countForEntity(entiry: String) -> Int {
        return storedData.count
    }
    
    func addRecords(records: [DeliveryItemModel], completion: @escaping (_ done: Bool) -> Void) {
        storedData.removeAll()
        for model in records {
            let convertedModel = self.convertModel(receivedModel: model)
            storedData.append(convertedModel)
        }
        
        completion(true)
    }
    
    private func convertModel(receivedModel: DeliveryItemModel) -> DeliveryItem {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mockModel = DeliveryItem(context: appDelegate.persistentContainer.viewContext)
        mockModel.id = Int64(Int(receivedModel.id ?? 0))
        mockModel.descriptionText = receivedModel.descriptionText
        mockModel.imageUrl = receivedModel.imageUrl
        mockModel.address = receivedModel.location?.address
        mockModel.lat = receivedModel.location?.lat ?? 0.0
        mockModel.lng = receivedModel.location?.lat ?? 0.0
        return mockModel
    }
    
}
