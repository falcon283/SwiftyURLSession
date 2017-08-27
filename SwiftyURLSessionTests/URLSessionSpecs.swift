//
//  URLSessionSpecs.swift
//  SwiftyURLSessionTests
//
//  Created by FaLcON2 on 25/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift

@testable import SwiftyURLSessionImp

class URLSessionSpecs : QuickSpec {
    
    override func spec() {
        
        let session = URLSession.shared
        
        describe("URLSessionSpecs") {
            
            context("when request expect response") {
                
                let request = try! Request(for: Mock.self)
                var mockResult: Mock? = nil
                
                beforeEach {
                    session.httpRequest(request) { result, _ in
                        mockResult = result
                    }
                }
                
                it("should have no error") {
                    expect(mockResult).toEventuallyNot(beNil())
                    try! expect(mockResult!.url) == Mock.url().absoluteString
                }
            }
            
            context("when request does not expect response") {
                
                let request = try! Request(for: Mock.self, parseData: false)
                var success: Bool? = nil
                
                beforeEach {
                    session.httpRequest(request) { response, _ in
                        success = response == nil ? true : false
                    }
                }
                
                it("should have no error") {
                    expect(success).toEventually(beTrue())
                }
            }
            
            context("when request fail") {
                
                let request = try! Request(for: MockError.self)
                var inError: Bool? = nil
                
                beforeEach {
                    session.httpRequest(request) { _, error in
                        inError = error != nil ? true : false
                    }
                }
                
                it("should have no error") {
                    expect(inError).toEventually(beTrue())
                }
            }
        }
        
        describe("URLSessionRxSpecs") {
            
            context("when object is expected") {
                
                let request = try! Request(for: Mock.self)
                let errorRequest = try! Request(for: MockError.self)
                
                context("and request succeed") {
                    
                    var object: Mock? = nil
                    
                    beforeEach {
                        _ = session.rx_httpRequest(request)
                            .subscribe(onNext: { object = $0 })
                    }
                    
                    it("should complete with no object") {
                        expect(object).toEventuallyNot(beNil())
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
            
            context("when object is not expected") {
                
                let request = try! Request(for: Mock.self, parseData: false)
                let errorRequest = try! Request(for: MockError.self, parseData: false)
                
                context("and request succeed") {
                    
                    var success: Bool? = nil
                    
                    beforeEach {
                        _ = session.rx_httpRequest(request)
                            .subscribe(onNext: { success = $0 == nil ? true : false })
                    }
                    
                    it("should complete with no object") {
                        expect(success).toEventually(beTrue())
                    }
                }
                
                context("and request fail") {
                    
                    var failure: Bool? = nil
                    
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
