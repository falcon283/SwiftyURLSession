//
//  URLRequest+Body.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

/**
 It's a convenience structure allows you to easily create a URLRequest with
 convenient values suitable for the operation. It is a generic class that
 allows to bind a specific type to the request and enforce swift type safety.
 */
public struct Request<R: Resource> {
    
    /// The resource type associated with the request.
    public let resourceType: R.Type
    
    var resultType: URLRequest.ContentType?
    
    /// The system URLRequest. It's generated using the initialization values and hold here for later use.
    var urlRequest: URLRequest
    
    /**
     Designated Initializer.
     
     - Parameter resource: The resource type to bind to the request. If the
     request success and the parseData is required this will be the output object.
     
     - Parameter authentication: If your endpoint require authentication you can
     use the authentication suitable for you. If you use this option the authentication
     will be stored in the `Authentication` request header. If you need to use a custom
     header name for the authentication, use the Authentication.encoded variable to
     obtain the authentication value and pass it alongside with the request header
     in your custom field. None by default.
     
     - Parameter method: the HTTP Method to use for the request. GET by default.
     
     - Parameter query: Additional supported parameters you would like to send along
     with your request. Nil by default.
     
     - Parameter headers: The additional header to use for the request. The options
     overwrite them if they overlap. Nil by default.
     
     - Parameter body: The vody to send alon with the request. Nil by default.
     
     - Parameter parseData: Determine if the response data should be parsed once
     received or not. True by default.
     
     - Throws: These are the error raised:
     
         **RequestError.invalidURL** if the Resource URL is not valid.
     
         **RequestError.invalidBody** if the body cannot be serialized.
     */
    public init(for resource: R.Type,
                authentication: URLRequest.Authentication = .none,
                method: URLRequest.HTTPMethod = .get,
                query: Query? = nil,
                headers: [String : String]? = nil,
                body: Body? = nil,
                parseData: Bool = true) throws {
    
        resourceType = resource
        resultType = parseData ? resource.acceptedContentType : nil
        urlRequest = try URLRequest(url: resource.url(),
                                    authentication: authentication,
                                    method: method,
                                    query: query,
                                    headers: headers,
                                    body: body,
                                    expecting: resultType)
    }
}

extension URLRequest {
    
    /// Private variable to easily setup the HTTP Method to the URLRequest.
    private var method: HTTPMethod? {
        get {
            return httpMethod.flatMap { HTTPMethod(rawValue: $0.uppercased()) }
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
    
    /// Private helper to set the authentication for the standard `Authentication` header.
    private mutating func setAuthentication(_ authentication: Authentication) {
        setHeader(key: "Authentication", value: authentication.encoded)
    }
    
    /// Private helper to set the `Accept` header for the request.
    private mutating func setResultType(_ type: ContentType?) {
        setHeader(key: "Accept", value: type?.description)
    }
    
    /// Private helper to set the `httpBody` for the request. It also set the `Content-Type` header in accordance to the body.
    private mutating func setBody(_ body: Body) throws {
        
        guard let data = body.makeData() else {
            throw BodyEncodeError.from(contentType: body.contentType)
        }
        
        setHeader(key: "Content-Type", value: body.contentType.description)
        httpBody = data
    }
    
    /** Private helper to set the header for the request. They are imediately applied,
     it means that options will owerwrite them if they overlap.
     */
    private mutating func setHeader(key: String, value: String?) {
        
        guard key.count > 0 else {
            return
        }
        
        if allHTTPHeaderFields == nil {
            allHTTPHeaderFields = [:]
        }
        
        allHTTPHeaderFields?[key] = value
    }
    
    /**
     Designated Initializer.
     
     - Parameter url: The url wused for the request.
     
     - Parameter authentication: If your endpoint require authentication you can
     use the authentication suitable for you. If you use this option the authentication
     will be stored in the `Authentication` request header. If you need to use a custom
     header name for the authentication, use the Authentication.encoded variable to
     obtain the authentication value and pass it alongside with the request header
     in your custom field. None by default.
     
     - Parameter method: the HTTP Method to use for the request. GET by default.
     
     - Parameter query: Additional supported parameters you would like to send along
     with your request. Nil by default.
     
     - Parameter headers: The additional header to use for the request. The options
     overwrite them if they overlap. Nil by default.
     
     - Parameter body: The vody to send alon with the request. Nil by default.
     
     - Parameter expecting: Determine the `Acccept` header. Nil by default.
     
     - Throws: These are the error raised:
     
         **RequestError.invalidURL** if the Resource URL is not valid.
     
         **RequestError.invalidBody** if the body cannot be serialized.
     */
    fileprivate init(url: URL,
                     authentication: Authentication = .none,
                     method: HTTPMethod = .get,
                     query: Query? = nil,
                     headers: [String : String]? = nil,
                     body: Body? = nil,
                     expecting: ContentType? = nil) throws {
        
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = query?.parameters.map { name, value in URLQueryItem(name: name, value: value) }
        
        guard let fullUrl = urlComponent?.url else {
            throw RequestError.invalidURL
        }
        
        self.init(url: fullUrl)
        
        // Provided Headers would be overriden if overlap the other options.
        self.allHTTPHeaderFields = headers
        
        self.setAuthentication(authentication)
        self.method = method
        
        if let body = body {
            do {
                try self.setBody(body)
            }
            catch {
                throw RequestError.invalidBody(encodeError: error as! BodyEncodeError)
            }
        }
        
        self.setResultType(expecting)
    }
}
