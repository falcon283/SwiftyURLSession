//
//  Body.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

/// A Body objects is able to be serialized and submitted as Body for an HTTP request.
public protocol Body {
    
    /// The content type for the HTTP request. It will determine the "Content-Type" HTTP Header
    var contentType: URLRequest.ContentType { get }
    
    /**
     Return the serialized data that will be used as HTTP Body.
     
     - Returns: The serialized data for the object.
     */
    func makeData() -> Data?
}

/// An opaque object that holds a PDF serialized Data.
public struct BodyPdf {
    
    /// The private data of the PDF.
    private let pdfData: Data?
    
    /**
     Designated Initializer.
     
     - Parameter pdf: The PDF Data.
     */
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

/// An opaque generic object that holds an Encodable entity that will be serialized as JSON.
public struct BodyJSON<T: Encodable> {
    
    /// The private object to serialize.
    private let object: T
    
    /// The private encoder used to encode the object.
    private var encoder: JSONEncoder
    
    /**
     Designated Initializer.
     
     - Parameter object: The object to serialize.
     - Parameter encoder: The JSON encoder to use for the serializer.
     */
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

/// An opaque generic object that holds an Encodable entity that will be serialized as XML.
public struct BodyXML<E: XMLEncoder> {
    
    /// The private object to serialize.
    private let object: E.T
    
    /// The XMLEncoder to use to encode the object.
    private let encoder: E
    
    /**
     Designated Initializer.
     
     - Parameter object: The object to serialize.
     - Parameter encoder: The encoder will serialize the object.
     */
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

/// An opaque generic object that holds an Encodable entity that will be serialized as GraphQL.
public struct BodyGraphQL<E: GraphQLEncoder> {
    
    /// The private object to serialize.
    private let object: E.T
    
    /// The private query type for the GraphQL.
    private let query: GraphQLQueryType
    
    /// The private variables to use for the GraphQL serialization.
    private let variables: [String : String]
    
    /// The GraphQLEncoder to use to encode the object.
    private let encoder: E
    
    /**
     Designated Initializer.
     
     - Parameter object: The object to serialize.
     - Parameter query: The query type to use for the serialization.
     - Parameter variables: The variables to use for the serialization.
     - Parameter encoder: The encoder will serialize the object.
     */
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

/// An opaque object that holds an String to serialize with a specific encoding.
public struct BodyEncodedString {

    /// The private string to encode.
    private let string: String
    
    /// The private encoding to use for the serialization.
    private let encoding: String.Encoding
    
    /**
     Designated Initializer.
     
     - Parameter string: The string to serialize.
     - Parameter encoding: The encoding to use for the serialization.
     */
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
