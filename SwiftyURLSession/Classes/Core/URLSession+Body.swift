//
//  URLSession+Body.swift
//  SwiftyURLSession
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
    public func dataRequest<R>(_ request: Request<R>,
                               startNow: Bool = true,
                               validator: @escaping (Validator) = URLSession.validateExcept4XX,
                               completion: ((R?, Error?)->())?) -> URLSessionDataTask {
        return dataTaskRequest(request.urlRequest, validator: validator) {
            self.finalizeTask(for: request, with: $0, error: $1, completion: completion)
        }.resumed(startNow)
    }
    
    @discardableResult
    public func uploadRequest<R>(_ request: Request<R>,
                                 data: Data,
                                 startNow: Bool = true,
                                 validator: @escaping (Validator) = URLSession.validateExcept4XX,
                                 completion: ((R?, Error?)->())?) -> URLSessionUploadTask {
        
        return uploadTaskRequest(request.urlRequest, data: data, validator: validator) {
            self.finalizeTask(for: request, with: $0, error: $1, completion: completion)
        }.resumed(startNow)
    }
    
    @discardableResult
    public func downloadRequest<R>(_ request: Request<R>,
                                   resumeData: Data? = nil,
                                   startNow: Bool = true,
                                   validator: @escaping (Validator) = URLSession.validateExcept4XX,
                                   completion: ((R?, Error?)->())?) -> URLSessionDownloadTask {
        
        return downloadTaskRequest(request.urlRequest, resumeData: resumeData, validator: validator) {
            self.finalizeTask(for: request, with: $0, error: $1, completion: completion)
        }.resumed(startNow)
    }
    
    private func finalizeTask<R>(for request: Request<R>, with data: Data?, error: Error?, completion: ((R?, Error?)->())?) {
        // Skip Processing if not requested
        guard let _ = completion else {
            return
        }
        
        guard error == nil else {
            completion?(nil, error!)
            return
        }
        
        if let _ = request.urlRequest.resultType {
            
            guard let data = data else {
                completion?(nil, HTTPRequestError.emptyResponseData)
                return
            }
            
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
    
    private func dataTaskRequest(_ request: URLRequest,
                                 validator: @escaping (Validator),
                                 completion: @escaping (Data?, Error?)->()) -> URLSessionDataTask {
        return dataTask(with: request) { (data, response, error) in
            
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
    }
    
    private func uploadTaskRequest(_ request: URLRequest,
                                   data: Data,
                                   validator: @escaping (Validator),
                                   completion: @escaping (Data?, Error?)->()) -> URLSessionUploadTask {
        
        return uploadTask(with: request, from: data) { (data, response, error) in
            
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
    }
    
    private func downloadTaskRequest(_ request: URLRequest,
                                     resumeData: Data? = nil,
                                     validator: @escaping (Validator),
                                     completion: @escaping (Data?, Error?)->()) -> URLSessionDownloadTask {
        
        func produceData(url: URL?, response: URLResponse?, error: Error?) {
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, HTTPRequestError.unknownResponse)
                return
            }
            
            guard let url = url else {
                completion(nil, HTTPRequestError.emptyResponseData)
                return
            }
            
            do {
                if validator(httpResponse.statusCode)  {
                    
                    let data = try Data(contentsOf: url)
                    completion(data, nil)
                }
                else {
                    completion(nil, HTTPRequestError.invalidResponse(statusCode: httpResponse.statusCode))
                }
            }
            catch {
                completion(nil, HTTPRequestError.emptyResponseData)
            }
        }
        
        if let resumeData = resumeData {
            return downloadTask(withResumeData: resumeData, completionHandler: produceData)
        }
        else {
            return downloadTask(with: request, completionHandler: produceData)
        }
    }
}

extension URLSession {
    
    public typealias Validator = (StatusCode)->(Bool)
    
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

extension URLSessionTask {
    
    @discardableResult
    func resumed(_ resumed: Bool = false) -> Self {
        if resumed {
            resume()
        }
        return self
    }
}
