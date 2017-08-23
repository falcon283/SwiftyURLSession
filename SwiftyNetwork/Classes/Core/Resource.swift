//
//  Resource.swift
//  SwiftyNetwork
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation

public protocol Query {
    var parameters: [String : String] { get }
}

public protocol Resource : Decodable {
    static var location: String { get }
    static var path: String { get }
}

extension Resource {
    internal static var url: URL? {
        return URL(string: location)?.appendingPathComponent(path)
    }
}