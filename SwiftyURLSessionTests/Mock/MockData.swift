//
//  TestResource.swift
//  SwiftyURLSessionTests
//
//  Created by FaLcON2 on 24/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation
import SwiftyURLSessionImp

struct TestResource : Resource {
    
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
    
    static func decode(data: Data) -> TestResource? {
        do {
            return try JSONDecoder().decode(TestResource.self, from: data)
        }
        catch {
            return nil
        }
    }
}

struct TestJSON : Encodable {
    var text: String
}

struct MockBody : Body {
    
    var returnData: Bool = true
    var contentType: URLRequest.ContentType
    
    func makeData() -> Data? {
        return returnData ? Data() : nil
    }
}
