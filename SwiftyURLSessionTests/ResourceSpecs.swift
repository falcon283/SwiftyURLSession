//
//  ResourceSpecs.swift
//  SwiftyURLSessionTests
//
//  Created by FaLcON2 on 24/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SwiftyURLSessionImp

class ResourceSpecs: QuickSpec {
    
    override func spec() {
        describe("Resource") {
            
            context("when getting resource url") {
                
                it("should have valid url") {
                    expect(try! TestResource.url()) == URL(string: "http://fake.com/resource")
                }
            }
            
            context("when getting wrong url") {
                
                struct WrongResource : Resource, Decodable {
                    static var location: String {
                        return ""
                    }
                    
                    static var path: String {
                        return ""
                    }
                    
                    static var acceptedContentType: URLRequest.ContentType {
                        return .json
                    }
                    
                    static func decode<O>(data: Data) -> O? where O : Decodable {
                        return nil
                    }
                }
                
                it("should have valid url") {
                    expect{ try WrongResource.url() }.to(throwError(URLRequest.RequestError.invalidURL))
                }
            }
            
            context("when decoding succeed") {
                
                let data = "{ \"test\": \"value\" }".data(using: .utf8)!
                
                it("should have valid result") {
                    let result: TestResource = TestResource.decode(data: data)!
                    expect(result.test) == "value"
                }
            }
            
            context("when decoding fail") {
                
                it("should have invalid result") {
                    let result: TestResource? = TestResource.decode(data: Data())
                    expect(result).to(beNil())
                }
            }
        }
    }
}
