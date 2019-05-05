//
// XCStub.swift
//  AssignmentTests
//
//  Created by Sandeep Kumar on 12/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import Foundation
import OHHTTPStubs

enum XCHTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case HEAD = "HEAD"
}

class XCStub {

   static func request(withPathRegex path: String, withResponseFile responseFile: String) {
        // Swift
        stub(condition: isHost(path)) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            let stubPath = FilePath(responseFile).path
            return fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
        }
    }

}

class FilePath {
    var fileName: String

    var path: String {

        let applicationDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last

        if let filePath = applicationDocumentsDirectory?.appendingPathComponent(fileName), FileManager.default.fileExists(atPath: filePath.absoluteString) {
            return filePath.absoluteString
        }

        let bundel = Bundle(for: type(of: self))

        if let filePath = bundel.path(forResource: fileName, ofType: nil), FileManager.default.fileExists(atPath: filePath) {
            return filePath
        }

        return fileName

    }

    init(_ fileName: String) {
        self.fileName = fileName
    }
}
