//
//  Resource.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

/// A Query object to use during the Resource serialization. Usually used during GET requests.
public protocol Query {
    
    /**
     The Key Value dictionary to use for the query.
     
     - Example: http://www.test.com/request?**key=value**
    */
    var parameters: [String : String] { get }
}

extension Dictionary: Query {
    public var parameters: [String: String] {
        return self as? [String: String] ?? [:]
    }
}

/**
 A Resource object conform to to Decodable protocol in order to allow
 its deserialization when received from the network request.
 */
public protocol Resource : Decodable {
    
    /// The location of the resource as base url.
    static var location: String { get }
    
    /// The path for the resource.
    static var path: String { get }
    
    /// The expected ContentType of the received data that will be used for the deserialization.
    static var acceptedContentType: URLRequest.ContentType { get }
    
    /**
     Decode the Data and return the Resource.
     
     - Parameter data: The data to deserialize.
     
     - Returns: The deserialized Resource.
     */
    static func decode(data: Data) -> Self?
}

extension Resource {

    /// A placeholder to build a dynamic path
    public static var placeholder: String { return "{p}" }

    /**
     The full URL for the resource.
     
     - Returns: The URL where the resource can be retrieved.
     */
    internal static func url(with placeholders: [String]? = nil) throws -> URL {

        let dynamicPath = placeholders?.reduce(path) { $0.replacingOccurrences(of: placeholder, with: $1) } ?? path
        guard let url = URL(string: location)?.appendingPathComponent(dynamicPath) else {
            throw URLRequest.RequestError.invalidURL
        }
        return url
    }
}
