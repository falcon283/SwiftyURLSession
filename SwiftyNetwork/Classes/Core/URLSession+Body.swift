//
//  URLSession+Body.swift
//  SwiftyNetwork
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

public extension URLSession {
    
    public enum HTTPRequestError: Error {
        case invalidResponse
        case response4xx
        case emptyResponseData
        case decodeError
    }
    
    public func httpRequest(with request: URLRequest, completion: ((Error?)->())?) -> URLSessionDataTask {
        return startDataTaskRequest(request) { (_, error) in
            completion?(error)
        }
    }
    
    public func httpRequest<R: Resource>(_ objectType: R.Type, with request: URLRequest, completion: ((R?, Error?)->())?) -> URLSessionDataTask {
        return startDataTaskRequest(request) { (data, error) in
            
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
            
            if let contentType = request.accept {
                guard let decoded = self.decodeData(data: data, to: objectType, for: contentType) else {
                    completion?(nil, HTTPRequestError.decodeError)
                    return
                }
                
                completion?(decoded, nil)
            }
            else {
                completion?(nil, nil)
            }
        }
    }
    
    private func startDataTaskRequest(_ request: URLRequest, completion: @escaping (Data?, Error?)->()) -> URLSessionDataTask {
        return dataTask(with: request) { (_, response, error) in
            
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, HTTPRequestError.invalidResponse)
                return
            }
            
            switch httpResponse.statusCode {
            case 400...499:
                completion(nil, HTTPRequestError.response4xx)
            default:
                completion(nil, nil)
            }
        }
    }
    
    private func decodeData<R: Resource>(data: Data, to type: R.Type, for contentType: URLRequest.ContentType) -> R? {
        switch contentType {
        case .graphql:
            return nil
        case .json:
            do {
                return try JSONDecoder().decode(type, from: data)
            }
            catch {
                return nil
            }
        case .xml:
            return nil
        case .text:
            return String(data: data, encoding: .utf8) as? R
            
        default:
            return nil
        }
    }
}
