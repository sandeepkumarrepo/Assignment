//
//  Utils.swift
//  Assignment
//
//  Created by Sandeep Kumar on 27/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation
import Reachability

class Utils {
    
    static func isNetworkAvailable() -> Bool {
        let status = Reachability()?.connection
        return (status == Reachability.Connection.none) ? false : true
    }
}
