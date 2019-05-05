//
//  CoreDataManager.swift
//  Assignment
//
//  Created by Sandeep Kumar on 15/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit
import CoreData
import Reachability

protocol CoreDataManagerInterface {
    func fetchRecords(offSet: Int, limit: Int) -> ([DeliveryItem]?, Error?)
    func deleteAllData(entity: String) -> Bool
    func addRecords(records: [DeliveryItemModel], completion: @escaping (_ done: Bool) -> Void)
    func countForEntity(entiry: String) -> Int
}

final class CoreDataManager: CoreDataManagerInterface {
    
    var managedContext: NSManagedObjectContext?
    
    init() {
        if Thread.isMainThread {
            managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? nil
            return
        }
        DispatchQueue.global().sync(execute: {
            DispatchQueue.main.sync {
                managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? nil
            }
        })
    }
    
    // Add records from received array
    func addRecords(records: [DeliveryItemModel], completion: @escaping (_ done: Bool) -> Void) {
        for record in records {
            self.addRecord(record: record)
        }
        completion(true)
    }
    
    func addRecord(record: DeliveryItemModel) {
        let entity = NSEntityDescription.entity(forEntityName: Constants.CoreDataEntity.deliveryItemEntity, in: self.managedContext!)
        let item = NSManagedObject(entity: entity!, insertInto: managedContext!)
        
        // Set the values
        item.setValue(record.id, forKeyPath: "id")
        item.setValue(record.descriptionText, forKeyPath: "descriptionText")
        item.setValue(record.imageUrl, forKeyPath: "imageUrl")
        item.setValue(record.location?.address, forKeyPath: "address")
        item.setValue(record.location?.lat, forKeyPath: "lat")
        item.setValue(record.location?.lng, forKeyPath: "lng")
        
        // save the record
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save the record. Error \(error)")
        }
    }
    
    // Fetch the records with received offset and limit
    func fetchRecords(offSet: Int, limit: Int = Constants.kFetchLimit) -> ([DeliveryItem]?, Error?) {
        print("CoreData Fetch Offset == \(offSet)")
        let request = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreDataEntity.deliveryItemEntity)
        request.fetchLimit = limit
        request.fetchOffset = offSet
        
        var error: Error?
        var items: [DeliveryItem]?
        do {
            items = try self.managedContext!.fetch(request) as? [DeliveryItem]
        } catch let err as NSError {
            print("Could not fetch the records. \(err), \(err.userInfo)")
            error = err
            return (items, error)
        }
        return (items, error)
    }
    
    func deleteAllData(entity: String) -> Bool {
        let managedContext = self.managedContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext?.execute(deleteRequest)
            try managedContext?.save()
            return true
        } catch {
            print ("There is an error in deleting records")
            return false
        }        
    }
}

// MARK: Count
extension CoreDataManager {
    
    func countForEntity(entiry: String) -> Int {
        let request = NSFetchRequest<NSManagedObject>(entityName: entiry)
        var count = 0
        do {
            count = try self.managedContext!.count(for: request)
        } catch let err as NSError {
            print("Could not fetch the records. \(err), \(err.userInfo)")
        }
        
        return count
    }
}
