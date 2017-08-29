//
//  URLSession+Body.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

public extension URLSession {
    
    /// The StatucCode for the responses.
    typealias StatusCode = Int
    
    /// The kind of errors can be returned executing a task.
    public enum HTTPRequestError: Error {
        
        /// The response is not an HTTPURLResponse thus unknown and currently unmanaged.
        case unknownResponse
        
        /// The response status code is not valid
        case invalidResponse(statusCode: Int)
        
        /// Empty respnse data.
        case emptyResponseData
        
        /// Decode Data was not possible.
        case decodeError(rawData: Data)
    }
    
    /**
     Execute a data request task. Prefer this task if you need to retrieve a small amount of data.
     Use downloadTask otherwise.
    
     - Parameter request: The kind of request to submit. The request is bound Resource to download.
     - Parameter startNow: This flag start the request imediately. Use false if you would like to
     resume the task manually using `resume` on `URLSessionDataTask`. True by default.
     - Parameter validator: The Response StatusCode validator function. Use this to specify what
     are the valid response status accepted. URLSession.validateExcept4XX by default.
     - Parameter completion: The completion closure called at the end of the task alongside with
     the parsed Resource if succeed or an error.

    - Returns: The dataTask to control the network activity.
    */
    @discardableResult
    public func dataRequest<R>(_ request: Request<R>,
                               startNow: Bool = true,
                               validator: @escaping (Validator) = URLSession.validateExcept4XX,
                               completion: ((R?, Error?)->())?) -> URLSessionDataTask {
        return dataTaskRequest(request.urlRequest, validator: validator) {
            self.finalizeTask(for: request, with: $0, error: $1, completion: completion)
        }.resumed(startNow)
    }
    
    /**
     Execute an upload request task.
     
     - Parameter request: The kind of request to submit. The request is bound Resource to download.
     - Parameter data: The raw data to upload.
     - Parameter startNow: This flag start the request imediately. Use false if you would like to
     resume the task manually using `resume` on `URLSessionUploadTask`. True by default.
     - Parameter validator: The Response StatusCode validator function. Use this to specify what
     are the valid response status accepted. URLSession.validateExcept4XX by default.
     - Parameter completion: The completion closure called at the end of the task alongside with
     the parsed Resource if succeed or an error.
     
     - Returns: The dataTask to control the network activity.
     */
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
    
    /**
     Execute an download request task.
     
     - Parameter request: The kind of request to submit. The request is bound Resource to download.
     - Parameter resumeData: The raw data previously downloaded to continue a previous stopped download task.
     - Parameter startNow: This flag start the request imediately. Use false if you would like to
     resume the task manually using `resume` on `URLSessionDownloadTask`. True by default.
     - Parameter validator: The Response StatusCode validator function. Use this to specify what
     are the valid response status accepted. URLSession.validateExcept4XX by default.
     - Parameter completion: The completion closure called at the end of the task alongside with
     the parsed Resource if succeed or an error.
     
     - Returns: The dataTask to control the network activity.
     */
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
    
    /**
     finalize the task execution.
     
     - Parameter request: The request to finalize.
     - Parameter data: The data received for the task if any.
     - Parameter error: The error received for the task if any.
     - Parameter completion: The completion to execute.
     */
    private func finalizeTask<R>(for request: Request<R>, with data: Data?, error: Error?, completion: ((R?, Error?)->())?) {
        // Skip Processing if not requested
        guard let _ = completion else {
            return
        }
        
        guard error == nil else {
            completion?(nil, error!)
            return
        }
        
        if let _ = request.resultType {
            
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
    
    /**
     It execute the data task.
     
     - Parameter request: The request to submit over the network.
     - Parameter validator: The validator to use for the Response Status Code.
     - Parameter completion: The completion to call.
     
     - Returns: The URLSessionDataTask for the request.
     */
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
    
    /**
     It execute the upload task.
     
     - Parameter request: The request to submit over the network.
     - Parameter data: The to upload.
     - Parameter validator: The validator to use for the Response Status Code.
     - Parameter completion: The completion to call.
     
     - Returns: The URLSessionUploadTask for the request.
     */
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
    
    /**
     It execute the download task
     
     - Parameter request: The request to submit over the network.
     - Parameter resumeData: The data to be used for the resume.
     - Parameter validator: The validator to use for the Response Status Code.
     - Parameter completion: The completion to call.
     
     - Returns: The URLSessionUploadTask for the request.
     */
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
    
    /// The validator function to use to validate the Response Status Code.
    public typealias Validator = (StatusCode)->(Bool)
    
    /**
     Validate only if Status Code is 200.
     
     - Parameter statusCode: The statusCode to validate.
     
     - Returns: True if the Status Code is valid, false otherwise.
     */
    public static func validate200(_ statusCode: StatusCode) -> Bool {
        return statusCode == 200
    }
    
    /**
     Validate only if Status Code is in 400...499 range.
     
     - Parameter statusCode: The statusCode to validate.
     
     - Returns: True if the Status Code is valid, false otherwise.
     */
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
    
    /**
     Internal helper function to resume or not a Task.
     
     - Parameter resumed: True if you want to resume the task. False by default.
     
     - Returns: The URLSessionTask itself.
     */
    @discardableResult
    func resumed(_ resumed: Bool = false) -> Self {
        if resumed {
            resume()
        }
        return self
    }
}
