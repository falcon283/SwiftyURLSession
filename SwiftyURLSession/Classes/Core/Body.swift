//
//  Body.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

public protocol Body {
    var contentType: URLRequest.ContentType { get }
    func makeData() -> Data?
}

public struct BodyPdf {
    let pdfData: Data?
    
    public init(pdfData: Data) {
        self.pdfData = pdfData
    }
}

extension BodyPdf : Body {
    public var contentType: URLRequest.ContentType {
        return .pdf
    }
    
    public func makeData() -> Data? {
        return pdfData
    }
}

public struct BodyJSON<T: Encodable> {
    
    let object: T
    public var encoder = JSONEncoder()
    
    public init(object: T) {
        self.object = object
    }
}

extension BodyJSON : Body {
    public var contentType: URLRequest.ContentType {
        return .json
    }
    
    public func makeData() -> Data? {
        do {
            return try encoder.encode(object)
        }
        catch {
            return nil
        }
    }
}

public struct BodyXML<T: Encodable> {
    let object: T
}

extension BodyXML : Body {
    public var contentType: URLRequest.ContentType {
        return .xml
    }
    
    public func makeData() -> Data? {
        // TODO
        return nil
    }
}

public struct BodyGraphQL {
    
    enum GQLType {
        case query
        case mutation
    }
    
    let type: GQLType
    let values: [String : Any]
    let variables: [[String: String]]
}

extension BodyGraphQL : Body {
    public var contentType: URLRequest.ContentType {
        return .graphql
    }
    
    public func makeData() -> Data? {
        // TODO
        return nil
    }
}

public struct BodyEncodedString {
    let encoding: String.Encoding
    let string: String
}

extension BodyEncodedString : Body {
    public var contentType: URLRequest.ContentType {
        return .text
    }
    
    public func makeData() -> Data? {
        return string.data(using: encoding)
    }
}

extension Data : Body {
    
    public var contentType: URLRequest.ContentType {
        return .binary
    }
    
    public func makeData() -> Data? {
        return self
    }
}