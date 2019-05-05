//
//  APIManager.swift
//  Assignment
//
//  Created by Sandeep Kumar on 13/04/19.
//  Copyright © 2019 Sandeep Kumar. All rights reserved.
//

import UIKit
import Alamofire

let kRequestTimeOutInterval: Int = 60

protocol APIManagerInterface {
    func requestWithURL(urlStr: String, params: [String: Any], httpMethod: HTTPMethod, completion: @escaping (Result<[DeliveryItemModel], Error>) -> Void)
}

final class APIManager: NSObject, APIManagerInterface {
    // MARK: Methods
    @discardableResult
    private func performRequestWithParams<T: Decodable>(urlString: String, params: [String: Any], httpMethod: HTTPMethod, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, Error>) -> Void) -> DataRequest {
        return AF.request(urlString, method: httpMethod, parameters: params).responseDecodable (decoder: decoder) { (response: DataResponse<T>) in
            completion(response.result)
        }
    }
    
    func requestWithURL(urlStr: String, params: [String: Any], httpMethod: HTTPMethod = HTTPMethod(rawValue: "GET")!, completion: @escaping (Result<[DeliveryItemModel], Error>) -> Void) {
        let result = self.checkValidUrl(urlStr: urlStr)
        switch result {
        case .failure:
            completion(result)
            return
        case .success:
            print("Valid Url")
        }
        
        let jsonDecoder = JSONDecoder()
        _ = performRequestWithParams(urlString: urlStr, params: params, httpMethod: httpMethod, decoder: jsonDecoder, completion: completion)
    }
    
    private func checkValidUrl(urlStr: String) -> Result<[DeliveryItemModel], Error> {
        guard URL(string: urlStr) != nil else {
            let error = NSError(domain: "Bad Request(Invalid URL)", code: 400, userInfo: nil) as Error
            return .failure(error)
        }
        return .success([])
    }
}
