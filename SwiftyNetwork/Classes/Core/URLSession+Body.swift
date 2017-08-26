//
//  URLSession+Body.swift
//  SwiftyNetwork
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation


public extension URLSession {
    
    typealias StatusCode = Int
    
    public enum HTTPRequestError: Error {
        case unknownResponse
        case invalidResponse(statusCode: Int)
        case emptyResponseData
        case decodeError(rawData: Data)
    }
    
    @discardableResult
    public func httpVoidRequest<R>(_ request: Request<R>,
                                   validator: @escaping ((StatusCode)->(Bool)) = URLSession.validateExcept4XX,
                                   completion: ((Error?)->())?) -> URLSessionDataTask {
        return startDataTaskRequest(request.urlRequest, validator: validator) { (_, error) in
            completion?(error)
        }
    }
    
    @discardableResult
    public func httpRequest<R>(_ request: Request<R>,
                               validator: @escaping ((StatusCode)->(Bool)) = URLSession.validateExcept4XX,
                               completion: ((R?, Error?)->())?) -> URLSessionDataTask {
        return startDataTaskRequest(request.urlRequest, validator: validator) { (data, error) in
            
            // Skip Processing if not requested
            guard let _ = completion else {
                return
            }
            
            guard error == nil else {
                completion?(nil, error!)
                return
            }
            
            guard let data = data else {
                completion?(nil, HTTPRequestError.emptyResponseData)
                return
            }
            
            if let _ = request.urlRequest.accept {
                guard let decoded = request.resourceType.decode(data: data) else {
                    completion?(nil, HTTPRequestError.decodeError(rawData: data))
                    return
                }
                
                completion?(decoded, nil)
            }
            else {
                completion?(nil, nil)
            }
        }
    }
    
    private func startDataTaskRequest(_ request: URLRequest,
                                      validator: @escaping ((StatusCode)->(Bool)),
                                      completion: @escaping (Data?, Error?)->()) -> URLSessionDataTask {
        let task = dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, HTTPRequestError.unknownResponse)
                return
            }
            
            if validator(httpResponse.statusCode) {
                completion(data, nil)
            }
            else {
                completion(nil, HTTPRequestError.invalidResponse(statusCode: httpResponse.statusCode))
            }
        }
        
        task.resume()
        return task
    }
}

extension URLSession {
    
    public static func validate200(_ statusCode: StatusCode) -> Bool {
        return statusCode == 200
    }
    
    public static func validateExcept4XX(_ statusCode: StatusCode) -> Bool {
        switch statusCode {
        case 400...499:
            return false
        default:
            return true
        }
    }
}
