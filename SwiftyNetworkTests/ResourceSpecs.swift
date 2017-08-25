//
//  ResourceSpecs.swift
//  SwiftyNetworkTests
//
//  Created by FaLcON2 on 24/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SwiftyNetwork

class ResourceSpecs: QuickSpec {
    
    override func spec() {
        describe("Resource") {
            
            context("when getting resource url") {
                
                it("should have valid url") {
                    expect(TestResource.url) == URL(string: "http://fake.com/resource")
                }
            }
            
            context("when decoding succeed") {
                
                let data = "{ \"test\": \"value\" }".data(using: .utf8)!
                
                it("should have valid result") {
                    let result = TestResource.decode(data: data)!
                    expect(result.test) == "value"
                }
            }
            
            context("when decoding fail") {
                
                it("should have invalid result") {
                    let result = TestResource.decode(data: Data())
                    expect(result).to(beNil())
                }
            }
        }
    }
}
