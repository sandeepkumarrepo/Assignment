//
//  Constants.swift
//  Assignment
//
//  Created by Sandeep Kumar on 12/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation

struct Constants {
    
    private init() {}
    struct Image {
        private init() {}
        static let kPlaceholderImage = "placeholder"
    }
    
    struct ImageDimension {
        private init() {}
        static let kCellImageHeight = 100.0
        static let kCellImageWidth = 100.0
    }
    
    struct Retry {
        private init() {}
        static let kMaxCount = 3
    }
    
    struct CoreDataEntity {
        private init() {}
        static let deliveryItemEntity = "DeliveryItem"
    }
    
    static let kBaseUrl = "https://mock-api-mobile.dev.lalamove.com/"
    static let kFetchLimit = 20
}

enum Endpoint: String {
    case deliveries = "deliveries"
}
