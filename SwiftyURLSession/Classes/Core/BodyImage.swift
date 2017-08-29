//
//  BodyImage.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 26/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import UIKit

/// This enum lists the kind of the images that can be serialized.
public enum BodyImage {
    
    /// A jpeg image.
    case jpeg(image: UIImage, compression: CGFloat)
    
    /// A png image.
    case png(image: UIImage)
    
    /// A binary image.
    case binary(data: Data, contentType: URLRequest.ContentType)

    /// The serialized raw Image.
    var rawImage: Data? {
        switch self {
        case let .jpeg(image, compression):
            return UIImageJPEGRepresentation(image, compression)
        case let .png(image):
            return UIImagePNGRepresentation(image)
        case let .binary(data: data, contentType: _):
            return data
        }
    }
}

extension BodyImage : Body {
    
    public var contentType: URLRequest.ContentType {
        switch self {
        case .jpeg(image: _, compression: _):
            return .jpeg
        case .png(image: _):
            return .png
        case let .binary(data: _, contentType: contentType):
            return contentType
        }
    }
    
    public func makeData() -> Data? {
        return rawImage
    }
}
