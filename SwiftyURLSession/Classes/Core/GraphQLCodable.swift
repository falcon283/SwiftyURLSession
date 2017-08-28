//
//  GraphQLCodable.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 27/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

public enum GraphQLQueryType {
    case query
    case mutation
}

public enum GraphQLEncoderError : Error {
    case encodeError
}

public protocol GraphQLEncoder {
    associatedtype T: Encodable
    func encode(_ object: T, variables: [String: String], query: GraphQLQueryType) throws -> Data?
}

extension GraphQLEncoder {
    func encode(_ object: T) throws -> Data? {
        return try encode(object, variables: [:])
    }
    
    func encode(_ object: T, variables: [String: String]) throws -> Data? {
        return try encode(object, variables: variables, query: .query)
    }
}

struct GraphQLInLineEncoder<T: Encodable> : GraphQLEncoder {
    
    public typealias GraphQLEncodeClosure = ((T, [String : String], GraphQLQueryType) -> Data?)
    
    private let encodeClosure: GraphQLEncodeClosure
    
    public init(_ closure: @escaping GraphQLEncodeClosure) {
        self.encodeClosure = closure
    }
    
    func encode(_ object: T, variables: [String : String], query: GraphQLQueryType) throws -> Data? {
        guard let data = encodeClosure(object, variables, query) else {
            throw GraphQLEncoderError.encodeError
        }
        return data
    }
}

public enum GraphQLDecoderError : Error {
    case decodeError
}

public protocol GraphQLDecoder {
    associatedtype T: Decodable
    func decode(_ data: Data) throws -> T
}

struct GraphQLInLineDecoder<T: Decodable> : GraphQLDecoder {
    
    public typealias GraphQLDecoderClosure = ((Data) -> T?)
    
    private let decodeClosure: GraphQLDecoderClosure
    
    public init(_ closure: @escaping GraphQLDecoderClosure) {
        self.decodeClosure = closure
    }
    
    func decode(_ data: Data) throws -> T {
        guard let object = decodeClosure(data) else {
            throw GraphQLDecoderError.decodeError
        }
        return object
    }
}

public struct GraphQLJSONDecoder<T: Decodable> : GraphQLDecoder{
    
    private let decoder: JSONDecoder
    private let objectType: T.Type
    
    public init(decoder: JSONDecoder, for type: T.Type) {
        self.decoder = decoder
        self.objectType = type
    }
    
    public func decode(_ data: Data) throws -> T {
        return try decoder.decode(objectType, from: data)
    }
}
