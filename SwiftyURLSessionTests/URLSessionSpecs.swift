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
            
            describe("DataRequest") {
                
                context("when expects response") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self)
                    var mockResult: Mock? = nil
                    
                    beforeEach {
                        session.dataRequest(request) { result, _ in
                            mockResult = result
                        }
                    }
                    
                    it("should have valid result") {
                        expect(mockResult).toEventuallyNot(beNil())
                        try! expect(mockResult!.url) == Mock.url().absoluteString
                    }
                }
                
                context("when does not expect response") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self, parseData: false)
                    var success: Bool? = nil
                    
                    beforeEach {
                        session.dataRequest(request) { response, _ in
                            success = response == nil ? true : false
                        }
                    }
                    
                    it("should succeed") {
                        expect(success).toEventually(beTrue())
                    }
                }
                
                context("when fails") {
                    
                    let request = try! Request(for: MockError.self, object: MockError.self)
                    var inError: Bool? = nil
                    
                    beforeEach {
                        session.dataRequest(request) { _, error in
                            inError = error != nil ? true : false
                        }
                    }
                    
                    it("should finish with error") {
                        expect(inError).toEventually(beTrue())
                    }
                }
            }
            
            describe("UploadRequest") {
                
                context("when expects response") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self)
                    var mockResult: Mock? = nil
                    
                    beforeEach {
                        session.uploadRequest(request, data: Data()) { result, _ in
                            mockResult = result
                        }
                    }
                    
                    it("should have valid result") {
                        expect(mockResult).toEventuallyNot(beNil())
                        try! expect(mockResult!.url) == Mock.url().absoluteString
                    }
                }
                
                context("when does not expect response") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self, parseData: false)
                    var success: Bool? = nil
                    
                    beforeEach {
                        session.uploadRequest(request, data: Data()) { response, _ in
                            success = response == nil ? true : false
                        }
                    }
                    
                    it("should succeed") {
                        expect(success).toEventually(beTrue())
                    }
                }
                
                context("when fails") {
                    
                    let request = try! Request(for: MockError.self, object: MockError.self)
                    var inError: Bool? = nil
                    
                    beforeEach {
                        session.uploadRequest(request, data: Data()) { _, error in
                            inError = error != nil ? true : false
                        }
                    }
                    
                    it("should finish with error") {
                        expect(inError).toEventually(beTrue())
                    }
                }
            }
            
            describe("DownloadRequest") {
                
                context("when expects response") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self)
                    var mockResult: Mock? = nil
                    
                    beforeEach {
                        session.downloadRequest(request) { result, _ in
                            mockResult = result
                        }
                    }
                    
                    it("should have valid result") {
                        expect(mockResult).toEventuallyNot(beNil())
                        try! expect(mockResult!.url) == Mock.url().absoluteString
                    }
                }
                
                context("when does not expect response") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self, parseData: false)
                    var success: Bool? = nil
                    
                    beforeEach {
                        session.downloadRequest(request) { response, _ in
                            success = response == nil ? true : false
                        }
                    }
                    
                    it("should succeed") {
                        expect(success).toEventually(beTrue())
                    }
                }
                
                context("when fails") {
                    
                    let request = try! Request(for: MockError.self, object: MockError.self)
                    var inError: Bool? = nil
                    
                    beforeEach {
                        session.downloadRequest(request) { _, error in
                            inError = error != nil ? true : false
                        }
                    }
                    
                    it("should finish with error") {
                        expect(inError).toEventually(beTrue())
                    }
                }
            }
        }
    }
}
