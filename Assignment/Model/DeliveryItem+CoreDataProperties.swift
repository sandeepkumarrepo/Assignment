//
//  DeliveryItem+CoreDataProperties.swift
//  
//
//  Created by Sandeep Kumar on 13/04/19.
//
//

import Foundation
import CoreData

extension DeliveryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeliveryItem> {
        return NSFetchRequest<DeliveryItem>(entityName: "DeliveryItem")
    }

    @NSManaged public var address: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageUrl: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double

}
