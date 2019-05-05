//
//  AppTheme.swift
//  Assignment
//
//  Created by Sandeep Kumar on 04/05/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation
import UIKit

struct AppTheme {
    
    private init() {}
    
    struct Font {
        private init() {}
        static let deliveryListViewCellFont = UIFont(name: "Helvetica", size: 17)
    }
    
    struct Color {
        private init() {}
        static let appToastMessageBackgroundColor = UIColor(red: 217/255.0, green: 96/255.0, blue: 86/255, alpha: 1.0)
    }
}
