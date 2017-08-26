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
import RxSwift

@testable import SwiftyNetwork

class URLSessionSpecs : QuickSpec {
    
    override func spec() {
        
        let session = URLSession.shared
        
        describe("URLSessionSpecs") {
            
            context("when request does not expect response") {
                
                let request = try! Request(for: Mock.self, query: MockQuery(test: true))
                var inError: Bool? = nil
                
                beforeEach {
                    session.httpVoidRequest(request) { error in
                        inError = error != nil ? true : false
                    }
                }
                
                it("should have no error") {
                    expect(inError).toEventually(beFalse())
                }
            }
            
            context("when request expect response") {
                
                let request = try! Request(for: Mock.self)
                var mockResult: Mock? = nil
                
                beforeEach {
                    session.httpRequest(request) { result, error in
                        mockResult = result
                    }
                }
                
                it("should have no error") {
                    expect(mockResult).toEventuallyNot(beNil())
                    try! expect(mockResult!.url) == Mock.url().absoluteString
                }
            }
            
            context("when request fail") {
                
                let request = try! Request(for: MockError.self)
                var inError: Bool? = nil
                
                beforeEach {
                    session.httpVoidRequest(request) { error in
                        inError = error != nil ? true : false
                    }
                }
                
                it("should have no error") {
                    expect(inError).toEventually(beTrue())
                }
            }
        }
        
        describe("URLSessionRxSpecs") {
            
            let request = try! Request(for: Mock.self)
            let errorRequest = try! Request(for: MockError.self)
            
            context("when object is not required") {
                
                context("and request succeed") {
                    
                    var success: Bool?
                    
                    beforeEach {
                        _ = session.rx_httpVoidRequest(request)
                            .subscribe(onNext: { _ in success = true })
                    }
                    
                    it("should complete with no object") {
                        expect(success).toEventually(beTrue())
                    }
                }
                
                context("and request fail") {
                    
                    var failure: Bool?
                    
                    beforeEach {
                        _ = session.rx_httpVoidRequest(errorRequest)
                            .subscribe(onError: { _ in failure = true })
                    }
                    
                    it("should complete with no object") {
                        expect(failure).toEventually(beTrue())
                    }
                }
            }
            
            context("when object is required") {
                
                context("and request succeed") {
                    
                    var success: Bool?
                    
                    beforeEach {
                        _ = session.rx_httpRequest(request)
                            .subscribe(onNext: { _ in success = true })
                    }
                    
                    it("should complete with no object") {
                        expect(success).toEventually(beTrue())
                    }
                }
                
                context("and request fail") {
                    
                    var failure: Bool?
                    
                    beforeEach {
                        _ = session.rx_httpRequest(errorRequest)
                            .subscribe(onError: { _ in failure = true })
                    }
                    
                    it("should complete with no object") {
                        expect(failure).toEventually(beTrue())
                    }
                }
            }
        }
    }
}
