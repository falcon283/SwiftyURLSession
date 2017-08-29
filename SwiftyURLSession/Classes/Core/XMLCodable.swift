//
//  XMLCodable.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 27/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

/// XML Encoding Errors
public enum XMLEncoderError : Error {
    
    /// Unable to serialize the given data.
    case encodeError
}

/// XML Encoder is able to serialize an Encodable.
public protocol XMLEncoder {
    
    /// The associated Encodable object with the Encoder.
    associatedtype T: Encodable
    
    /**
     Serialize the input object.
     
     - Parameter object: The object to serialize as XML.
     
     - Throws: XMLEncoderError.encodeError if serialization fails.
     
     - Returns: The serialized XML data.
     */
    func encode(_ object: T) throws -> Data
}

struct XMLInLineEncoder<T: Encodable> : XMLEncoder {
    
    /// The function type for the encoding.
    public typealias XMLEncodeClosure = ((T) -> Data?)
    
    /// The encoding closure. This cloure is responsible for the actual encoding of the object into XML format.
    private let encodeClosure: XMLEncodeClosure
    
    /**
     Designated Initializer
     
     - Parameter closure: The encoding closure.
     */
    public init(_ closure: @escaping XMLEncodeClosure) {
        self.encodeClosure = closure
    }
    
    func encode(_ object: T) throws -> Data {
        guard let data = encodeClosure(object) else {
            throw XMLEncoderError.encodeError
        }
        return data
    }
}

/// XML Dencoding Errors
public enum XMLDecoderError : Error {
    
    /// Unable to deserialize the given object.
    case decodeError
}

/// XML Decoder is able to deserialize a Dencodable
public protocol XMLDecoder {
    
    /// The associated Decodable object with the Decoder.
    associatedtype T: Decodable
    
    /**
     Deserialize the input data into the given object.
     
     - Parameter data: The data to deserialize.
     
     - Throws: XMLDecoderError.decodeError if the deserialization fails.
     
     - Returns: The deserialized object.
     */
    func decode(_ data: Data) throws -> T
}

/// A XML Decoder that use the given closure for the decoding.
struct XMLInLineDecoder<T: Decodable> : XMLDecoder {
    
    /// The function type for the decoding.
    public typealias XMLDecodeClosure = ((Data) -> T?)
    
    /// The decoding closure.
    private let decodeClosure: XMLDecodeClosure
    
    /**
     Designated Initializer
     
     - Parameter closure: The decoding closure.
     */
    public init(_ closure: @escaping XMLDecodeClosure) {
        self.decodeClosure = closure
    }
    
    func decode(_ data: Data) throws -> T {
        guard let object = decodeClosure(data) else {
            throw XMLDecoderError.decodeError
        }
        return object
    }
}
