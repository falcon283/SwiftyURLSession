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
    private let pdfData: Data?
    
    public init(for pdf: Data) {
        self.pdfData = pdf
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
    
    private let object: T
    private var encoder: JSONEncoder
    
    public init(for object: T, with encoder: JSONEncoder) {
        self.object = object
        self.encoder = encoder
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

public struct BodyXML<E: XMLEncoder> {
    private let object: E.T
    private let encoder: E
    
    public init(for object: E.T, with encoder: E) {
        self.object = object
        self.encoder = encoder
    }
}

extension BodyXML : Body {
    public var contentType: URLRequest.ContentType {
        return .xml
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

public struct BodyGraphQL<E: GraphQLEncoder> {
    
    private let object: E.T
    private let query: GraphQLQueryType
    private let variables: [String : String]
    private let encoder: E
    
    public init(for object: E.T, query: GraphQLQueryType, variables: [String : String] = [:], with encoder: E) {
        self.object = object
        self.query = query
        self.variables = variables
        self.encoder = encoder
    }
}

extension BodyGraphQL : Body {
    public var contentType: URLRequest.ContentType {
        return .graphql
    }
    
    public func makeData() -> Data? {
        do {
            return try encoder.encode(object, variables: variables, query: query)
        }
        catch {
            return nil
        }
    }
}

public struct BodyEncodedString {
    private let encoding: String.Encoding
    private let string: String
    
    public init(for string: String, in encoding: String.Encoding) {
        self.string = string
        self.encoding = encoding
    }
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
