//
//  URLRequest+Types.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 30/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

extension URLRequest {
    
    /// The HTTP methods available.
    public enum HTTPMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
    
    /// The available authentications
    public enum Authentication {
        
        /// No authentication required.
        case none
        
        /// Basic authentication required. Provide Username and Password. The format used is `Basic Base64(username:password)`.
        case basic(username: String, password: String)
        
        /// oauth2 Authentication. Provide the name of the authentication and the secret. The format used is `name secret`.
        case oauth2(name: String, secret: String)
        
        /// The encoded value for the
        public var encoded: String? {
            switch self {
            case let .basic(username, password):
                let utf8 = "\(username):\(password)".data(using: .utf8)
                let base64 = utf8?.base64EncodedString()
                return base64.flatMap { "Basic \($0)" }
            case let .oauth2(name, secret):
                return "\(name) \(secret)"
            default:
                return nil
            }
        }
    }
    
    /// The `Content-Type`s for the body and accepted response.
    public enum ContentType: CustomStringConvertible, Equatable {
        
        /// Binary data.
        case binary
        
        /// Used for GraphQL body.
        case graphql
        
        /// Used for Jpeg incoming data.
        case jpeg
        
        /// Used for JSON body and incoming data.
        case json
        
        /// Used for PDF incoming data.
        case pdf
        
        /// Used for Png incoming data.
        case png
        
        /// Used for text body and incoming data.
        case text
        
        /// Used for body and incoming data.
        case xml
        
        /// Used for Zipped body and incoming data.
        case zip
        
        // TODO: Multipart
        
        /// Used for custom type.
        case custom(type: String)
        
        public var description: String {
            switch self {
            case .binary:
                return "application/octet-stream"
            case .graphql:
                return "application/graphql"
            case .jpeg:
                return "application/jpeg"
            case .json:
                return "application/json"
            case .pdf:
                return "application/pdf"
            case .png:
                return "application/png"
            case .text:
                return "application/text"
            case .xml:
                return "application/xml"
            case .zip:
                return "application/zip"
            case .custom(type: let type):
                return type
            }
        }
        
        public static func ==(lhs: ContentType, rhs: ContentType) -> Bool {
            return lhs.description == rhs.description
        }
    }
    
    /// The Body Encoding errors.
    public enum BodyEncodeError: Error {
        
        /// Unable to encode as Binary.
        case invalidBinary
        
        /// Unable to encode as GraphQL.
        case invalidGraphQL
        
        /// Unable to encode as Jpeg.
        case invalidJPEG
        
        /// Unable to encode as JSON.
        case invalidJSON
        
        /// Unable to encode as Png.
        case invalidPNG
        
        /// Unable to encode as Pdf.
        case invalidPDF
        
        /// Unable to encode as Text.
        case invalidString
        
        /// Unable to encode as XML.
        case invalidXML
        
        /// Unable to encode as Zip
        case invalidZIP
        
        /// Unable to encode as Custom.
        case invalid(type: String)
        
        /// Mapping function to convert ContentType in its related encoding error.
        static func from(contentType: ContentType) -> BodyEncodeError {
            switch contentType {
            case .binary:
                return .invalidBinary
            case .graphql:
                return .invalidGraphQL
            case .jpeg:
                return .invalidJPEG
            case .json:
                return .invalidJSON
            case .png:
                return .invalidPNG
            case .pdf:
                return .invalidPDF
            case .text:
                return .invalidString
            case .xml:
                return .invalidXML
            case .zip:
                return .invalidZIP
            case .custom(type: let type):
                return .invalid(type: type)
            }
        }
    }
    
    /// The request errors.
    public enum RequestError : Error {
        
        /// Invalid URL. Unable to form the URL due to invalid schema, location or path components.
        case invalidURL
        
        /// Body Serialization failed.
        case invalidBody(encodeError: BodyEncodeError)
    }
}
