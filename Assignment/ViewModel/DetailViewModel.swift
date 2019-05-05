//
//  DetailViewModel.swift
//  Assignment
//
//  Created by Sandeep Kumar on 16/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit
import CoreData

class DetailViewModel: NSObject {
    
   @objc var model: DeliveryItemModel?
    
    convenience init (model: DeliveryItemModel) {
        self.init()
        self.model = model
    }
}
