//
//  URLSessionSpecs.swift
//  SwiftyNetworkTests
//
//  Created by FaLcON2 on 25/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SwiftyNetwork

class URLSessionSpecs : QuickSpec {
    
    override func spec() {
        
        describe("URLSessionSpecs") {
            
            let session = URLSession.shared
            
            context("when request does not expect response") {
                
                let request = try! URLRequest(for: Mock.self, query: MockQuery(test: true))
                var inError: Bool? = nil
                
                beforeEach {
                    session.httpRequest(with: request) { error in
                        inError = error != nil ? true : false
                    }
                }
                
                it("should have no error") {
                    expect(inError).toEventually(beFalse())
                }
            }
            
            context("when request expect response") {
                
                let request = try! URLRequest(for: Mock.self, accepting: .json)
                var mockResult: Mock? = nil
                
                beforeEach {
                    session.httpRequest(Mock.self, with: request) { result, error in
                        mockResult = result
                    }
                }
                
                it("should have no error") {
                    expect(mockResult).toEventuallyNot(beNil())
                    expect(mockResult!.url) == Mock.url?.absoluteString
                }
            }
            
            context("when request fail") {
                
                let request = try! URLRequest(for: MockError.self)
                var inError: Bool? = nil
                
                beforeEach {
                    session.httpRequest(with: request) { error in
                        inError = error != nil ? true : false
                    }
                }
                
                it("should have no error") {
                    expect(inError).toEventually(beTrue())
                }
            }
        }
    }
}
