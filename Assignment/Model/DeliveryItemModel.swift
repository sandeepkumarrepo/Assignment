//
//  DeliveryItemModel.swift
//  Assignment
//
//  Created by Sandeep Kumar on 14/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit
import Foundation

@objc class DeliveryItemModel: NSObject, Codable {
    var id: Int?
    var descriptionText: String?
    var imageUrl: String?
    var location: Location?
}

extension DeliveryItemModel {
    enum CodingKeys: String, CodingKey {
        case id
        case descriptionText = "description"
        case imageUrl
        case location
    }
}
