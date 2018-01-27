//
//  TestResource.swift
//  SwiftyURLSessionTests
//
//  Created by FaLcON2 on 24/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation
import SwiftyURLSessionImp

struct TestResource : Resource, Decodable {
    
    let test: String
    
    static var location: String {
        return "http://fake.com"
    }
    
    static var path: String {
        return "resource"
    }
    
    static var acceptedContentType: URLRequest.ContentType {
        return .json
    }

    static func decode<O>(data: Data) -> O? where O : Decodable {
        do {
            return try JSONDecoder().decode(O.self, from: data)
        }
        catch {
            return nil
        }
    }
}

struct TestDynamicResource : Resource, Decodable {

    let test: String

    static var location: String {
        return "http://fake.com"
    }

    static var path: String {
        return "resource\(placeholder)"
    }

    static var acceptedContentType: URLRequest.ContentType {
        return .json
    }

    static func decode<O>(data: Data) -> O? where O : Decodable {
        do {
            return try JSONDecoder().decode(O.self, from: data)
        }
        catch {
            return nil
        }
    }
}

struct TestCodable : Codable {
    var text: String
}

struct MockBody : Body {
    
    var returnData: Bool = true
    var contentType: URLRequest.ContentType
    
    func makeData() -> Data? {
        return returnData ? Data() : nil
    }
}
