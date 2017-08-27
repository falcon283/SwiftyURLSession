//
//  XMLCodable.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 27/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

public enum XMLEncoderError : Error {
    case encodeError
}

public protocol XMLEncoder {
    associatedtype T: Encodable
    func encode(_ object: T) throws -> Data
}

struct XMLInLineEncoder<T: Encodable> : XMLEncoder {
    
    public typealias XMLEncodeClosure = ((T) -> Data?)
    
    private let encodeClosure: XMLEncodeClosure
    
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

public enum XMLDecoderError : Error {
    case decodeError
}

public protocol XMLDecoder {
    associatedtype T: Decodable
    func decode(_ data: Data) throws -> T
}

struct XMLInLineDecoder<T: Decodable> : XMLDecoder {
    
    public typealias XMLDecodeClosure = ((Data) -> T?)
    
    private let decodeClosure: XMLDecodeClosure
    
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
