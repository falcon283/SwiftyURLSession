//
//  URLRequest+Body.swift
//  SwiftyNetwork
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

public struct Request<R: Resource> {
    
    public let resourceType: R.Type
    var urlRequest: URLRequest
    
    public init(for resource: R.Type,
                authentication: URLRequest.Authentication = .none,
                method: URLRequest.HTTPMethod = .get,
                query: Query? = nil,
                headers: [String : String]? = nil,
                body: Body? = nil,
                accepting: URLRequest.ContentType = .json) throws {
    
        resourceType = resource
        urlRequest = try URLRequest(url: resource.url(),
                                    authentication: authentication,
                                    method: method,
                                    query: query,
                                    headers: headers,
                                    body: body,
                                    accepting: accepting)
    }
}

public extension URLRequest {
    
    public enum HTTPMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
    
    private var method: HTTPMethod? {
        get {
            return httpMethod.flatMap { HTTPMethod(rawValue: $0.uppercased()) }
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
    
    public enum Authentication {
        case none
        case basic(username: String, password: String)
        case oauth2(name: String, secret: String)
        
        fileprivate var encoded: String? {
            switch self {
            case let .basic(username, password):
                let utf8 = "\(username):\(password)".data(using: .utf8)
                let base64 = utf8?.base64EncodedString()
                return base64.flatMap { "Basic \($0)" }
            case let .oauth2(name, secret):
                return "\(name) \(secret)"
            default:
                return nil
            }
        }
    }
    
    private mutating func setAuthentication(_ authentication: Authentication) {
        setHeader(key: "Authentication", value: authentication.encoded)
    }
    
    public enum ContentType: String {
        case binary = "application/octet-stream"
        case graphql = "application/graphql"
        case jpeg = "application/jpeg"
        case json = "application/json"
        case pdf = "application/pdf"
        case png = "application/png"
        case text = "application/text"
        case xml = "application/xml"
        case zip = "application/zip"
        // TODO: Multipart
    }
    
    internal var accept: ContentType? {
        get {
            return allHTTPHeaderFields?["Accept"].flatMap { ContentType(rawValue: $0) }
        }
        set {
            setHeader(key: "Accept", value: newValue?.rawValue)
        }
    }
    
    private var contentType: ContentType? {
        return allHTTPHeaderFields?["Content-Type"].flatMap { ContentType(rawValue: $0) }
    }
    
    public enum BodyEncodeError: Error {
        case invalidBinary
        case invalidGraphQL
        case invalidJPEG
        case invalidJSON
        case invalidPNG
        case invalidPDF
        case invalidString
        case invalidXML
        case invalidZIP
        
        fileprivate static func from(contentType: ContentType) -> BodyEncodeError {
            switch contentType {
            case .binary:
                return .invalidBinary
            case .graphql:
                return .invalidGraphQL
            case .jpeg:
                return .invalidJPEG
            case .json:
                return .invalidJSON
            case .png:
                return .invalidPNG
            case .pdf:
                return .invalidPDF
            case .text:
                return .invalidString
            case .xml:
                return .invalidXML
            case .zip:
                return .invalidZIP
            }
        }
    }
    
    private mutating func setBody(_ body: Body) throws {
        
        guard let data = body.makeData() else {
            throw BodyEncodeError.from(contentType: body.contentType)
        }
        
        setHeader(key: "Content-Type", value: body.contentType.rawValue)
        httpBody = data
    }
    
    private mutating func setHeader(key: String, value: String?) {
        
        guard key.count > 0 else {
            return
        }
        
        if allHTTPHeaderFields == nil {
            allHTTPHeaderFields = [:]
        }
        
        allHTTPHeaderFields?[key] = value
    }
    
    public enum RequestError : Error {
        case invalidURL
        case invalidBody(encodeError: BodyEncodeError)
    }
    
    fileprivate init(url: URL,
                     authentication: Authentication = .none,
                     method: HTTPMethod = .get,
                     query: Query? = nil,
                     headers: [String : String]? = nil,
                     body: Body? = nil,
                     accepting: ContentType = .json) throws {
        
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
        
        self.accept = accepting
    }
}
