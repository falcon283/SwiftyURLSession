//
//  RemoteMock.swift
//  SwiftyURLSessionTests
//
//  Created by FaLcON2 on 25/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation
import SwiftyURLSessionImp

struct Mock : Decodable {
    let args: [String: String]
    let headers: [String: String]
    let origin: String
    let url: String
}

struct MockQuery : Query {
    let test: Bool
    
    var parameters: [String : String] {
        return ["test" : "\(test)"]
    }
}

extension Mock : Resource {
    static var location: String {
        return "https://httpbin.org"
    }
    static var path: String {
        return "get"
    }
    
    static var acceptedContentType: URLRequest.ContentType {
        return .json
    }
    
    static func decode(data: Data) -> Mock? {
        do {
            return try JSONDecoder().decode(Mock.self, from: data)
        }
        catch {
            return nil
        }
    }
}

struct MockError : Decodable { }

extension MockError : Resource {
    static var location: String {
        return "https://httpbin.org"
    }
    static var path: String {
        return "error"
    }
    
    static var acceptedContentType: URLRequest.ContentType {
        return .json
    }
    
    static func decode(data: Data) -> MockError? {
        return nil
    }
}
