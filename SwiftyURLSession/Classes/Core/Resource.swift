//
//  Resource.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

public protocol Query {
    var parameters: [String : String] { get }
}

public protocol Resource : Decodable {
    static var location: String { get }
    static var path: String { get }
    
    static var acceptedContentType: URLRequest.ContentType { get }
    static func decode(data: Data) -> Self?
}

extension Resource {
    internal static func url() throws -> URL {
        guard let url = URL(string: location)?.appendingPathComponent(path) else {
            throw URLRequest.RequestError.invalidURL
        }
        return url
    }
}
