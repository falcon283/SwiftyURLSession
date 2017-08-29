//
//  GraphQLCodable.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 27/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

/// The type of the GraphQL query.
public enum GraphQLQueryType {
    
    /// GraphQL query.
    case query
    
    /// GraphQL mutation.
    case mutation
}

/// GraphQL Encoding Errors
public enum GraphQLEncoderError : Error {
    
    /// Unable to serialize the given data.
    case encodeError
}

/// GraphQL Encoder is able to serialize an Encodable.
public protocol GraphQLEncoder {
    
    /// The associated Encodable object with the Encoder.
    associatedtype T: Encodable
    
    /**
     Serialize the input object.
     
     - Parameter object: The object to serialize as GraphQL.
     - Parameter variables: The variables to use for the serialization. Default is empty.
     - Parameter query: The query to use for the serialization. Default is .query

     - Throws: GraphQLEncoderError.encodeError if serialization fails.
     
     - Returns: The serialized GraphQL data.
     */
    func encode(_ object: T, variables: [String: String], query: GraphQLQueryType) throws -> Data
}

extension GraphQLEncoder {
    
    /**
     Serialize the input object.
     
     - Parameter object: The object to serialize as GraphQL.
     
     - Throws: GraphQLEncoderError.encodeError if serialization fails.
     
     - Returns: The serialized GraphQL data.
     */
    func encode(_ object: T) throws -> Data {
        return try encode(object, variables: [:])
    }

    /**
     Serialize the input object.
     
     - Parameter object: The object to serialize as GraphQL.
     - Parameter variables: The variables to use for the serialization. Default is empty.
     
     - Throws: GraphQLEncoderError.encodeError if serialization fails.
     
     - Returns: The serialized GraphQL data.
     */
    func encode(_ object: T, variables: [String: String]) throws -> Data {
        return try encode(object, variables: variables, query: .query)
    }
}

/// A GraphQL Encoder that use the given closure for the encoding.
struct GraphQLInLineEncoder<T: Encodable> : GraphQLEncoder {
    
    /// The function type for the encoding.
    public typealias GraphQLEncodeClosure = ((T, [String : String], GraphQLQueryType) -> Data?)
    
    /// The encoding closure. This cloure is responsible for the actual encoding of the object into GraphQL format.
    private let encodeClosure: GraphQLEncodeClosure
    
    /**
     Designated Initializer
     
     - Parameter closure: The encoding closure.
     */
    public init(_ closure: @escaping GraphQLEncodeClosure) {
        self.encodeClosure = closure
    }
    
    func encode(_ object: T, variables: [String : String], query: GraphQLQueryType) throws -> Data {
        guard let data = encodeClosure(object, variables, query) else {
            throw GraphQLEncoderError.encodeError
        }
        return data
    }
}

/// GraphQL Encoding Errors
public enum GraphQLDecoderError : Error {
    
    /// Unable to deserialize the given object.
    case decodeError
}

/// GraphQL Decoder is able to deserialize a Dencodable
public protocol GraphQLDecoder {
    
    /// The associated Decodable object with the Decoder.
    associatedtype T: Decodable
    
    /**
     Deserialize the input data into the given object.
     
     - Parameter data: The data to deserialize.
     
     - Throws: GraphQLDecoderError.decodeError if the deserialization fails.
     
     - Returns: The deserialized object.
     */
    func decode(_ data: Data) throws -> T
}

/// A GraphQL Decoder that use the given closure for the decoding.
struct GraphQLInLineDecoder<T: Decodable> : GraphQLDecoder {
    
    /// The function type for the decoding.
    public typealias GraphQLDecoderClosure = ((Data) -> T?)
    
    /// The decoding closure.
    private let decodeClosure: GraphQLDecoderClosure
    
    /**
     Designated Initializer
     
     - Parameter closure: The decoding closure.
     */
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

/// A GraphQL Dncoder that use the given JSONDecoder to decode the data.
public struct GraphQLJSONDecoder<T: Decodable> : GraphQLDecoder {
    
    /// The private type of object to deserialize the data.
    private let objectType: T.Type
    
    // The private JSONDecoder to use during the deserialization.
    private let decoder: JSONDecoder
    
    /**
     Designated Initializer.
     
     - Parameter decoder: The JSONEncoder to use for the deserialization.
     - Parameter type: The kind of object to trasfrom the data.
     */
    public init(decoder: JSONDecoder, for type: T.Type) {
        self.decoder = decoder
        self.objectType = type
    }
    
    public func decode(_ data: Data) throws -> T {
        return try decoder.decode(objectType, from: data)
    }
}
