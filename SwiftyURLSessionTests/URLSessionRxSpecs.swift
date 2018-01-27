//
//  URLSessionRxSpecs.swift
//  SwiftyURLSessionTests
//
//  Created by FaLcON2 on 28/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift

@testable import SwiftyURLSessionImp

class URLSessionRxSpecs : QuickSpec {
    
    override func spec() {
        
        let session = URLSession.shared
        
        describe("URLSessionRxSpecs") {
            
            context("DataRequest") {
                
                context("when object is expected") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self)
                    let errorRequest = try! Request(for: MockError.self, object: MockError.self)
                    
                    context("and request succeed") {
                        
                        var object: Mock? = nil
                        
                        beforeEach {
                            _ = session.rxDataRequest(request)
                                .map { $0.result }
                                .subscribe(onNext: { object = $0 })
                        }
                        
                        it("should complete with no object") {
                            expect(object).toEventuallyNot(beNil())
                        }
                    }
                    
                    context("and request fail") {
                        
                        var failure: Bool?
                        
                        beforeEach {
                            _ = session.rxDataRequest(errorRequest)
                                .subscribe(onError: { _ in failure = true })
                        }
                        
                        it("should complete with no object") {
                            expect(failure).toEventually(beTrue())
                        }
                    }
                }
                
                context("when object is not expected") {
                    
                    let request = try! Request(for: Mock.self, object: TestResource.self, parseData: false)
                    let errorRequest = try! Request(for: MockError.self, object: TestResource.self, parseData: false)
                    
                    context("and request succeed") {
                        
                        var success: Bool? = nil
                        
                        beforeEach {
                            _ = session.rxDataRequest(request)
                                .map { $0.result }
                                .subscribe(onNext: { success = $0 == nil ? true : false })
                        }
                        
                        it("should complete with no object") {
                            expect(success).toEventually(beTrue())
                        }
                    }
                    
                    context("and request fail") {
                        
                        var failure: Bool? = nil
                        
                        beforeEach {
                            _ = session.rxDataRequest(errorRequest)
                                .subscribe(onError: { _ in failure = true })
                        }
                        
                        it("should complete with no object") {
                            expect(failure).toEventually(beTrue())
                        }
                    }
                }
            }
            
            context("UploadRequest") {
                
                context("when object is expected") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self)
                    let errorRequest = try! Request(for: MockError.self, object: MockError.self)
                    
                    context("and request succeed") {
                        
                        var object: Mock? = nil
                        
                        beforeEach {
                            _ = session.rxUploadRequest(request, data: Data())
                                .map { $0.result }
                                .subscribe(onNext: { object = $0 })
                        }
                        
                        it("should complete with no object") {
                            expect(object).toEventuallyNot(beNil())
                        }
                    }
                    
                    context("and request fail") {
                        
                        var failure: Bool?
                        
                        beforeEach {
                            _ = session.rxUploadRequest(errorRequest, data: Data())
                                .subscribe(onError: { _ in failure = true })
                        }
                        
                        it("should complete with no object") {
                            expect(failure).toEventually(beTrue())
                        }
                    }
                }
                
                context("when object is not expected") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self, parseData: false)
                    let errorRequest = try! Request(for: MockError.self, object: MockError.self, parseData: false)
                    
                    context("and request succeed") {
                        
                        var success: Bool? = nil
                        
                        beforeEach {
                            _ = session.rxUploadRequest(request, data: Data())
                                .map { $0.result }
                                .subscribe(onNext: { success = $0 == nil ? true : false })
                        }
                        
                        it("should complete with no object") {
                            expect(success).toEventually(beTrue())
                        }
                    }
                    
                    context("and request fail") {
                        
                        var failure: Bool? = nil
                        
                        beforeEach {
                            _ = session.rxUploadRequest(errorRequest, data: Data())
                                .subscribe(onError: { _ in failure = true })
                        }
                        
                        it("should complete with no object") {
                            expect(failure).toEventually(beTrue())
                        }
                    }
                }
            }
            
            context("DownloadRequest") {
                
                context("when object is expected") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self)
                    let errorRequest = try! Request(for: MockError.self, object: MockError.self)
                    
                    context("and request succeed") {
                        
                        var object: Mock? = nil
                        
                        beforeEach {
                            _ = session.rxDownloadRequest(request)
                                .map { $0.result }
                                .subscribe(onNext: { object = $0 })
                        }
                        
                        it("should complete with no object") {
                            expect(object).toEventuallyNot(beNil())
                        }
                    }
                    
                    context("and request fail") {
                        
                        var failure: Bool?
                        
                        beforeEach {
                            _ = session.rxDownloadRequest(errorRequest)
                                .subscribe(onError: { _ in failure = true })
                        }
                        
                        it("should complete with no object") {
                            expect(failure).toEventually(beTrue())
                        }
                    }
                }
                
                context("when object is not expected") {
                    
                    let request = try! Request(for: Mock.self, object: Mock.self, parseData: false)
                    let errorRequest = try! Request(for: MockError.self, object: MockError.self, parseData: false)
                    
                    context("and request succeed") {
                        
                        var success: Bool? = nil
                        
                        beforeEach {
                            _ = session.rxDownloadRequest(request)
                                .map { $0.result }
                                .subscribe(onNext: { success = $0 == nil ? true : false })
                        }
                        
                        it("should complete with no object") {
                            expect(success).toEventually(beTrue())
                        }
                    }
                    
                    context("and request fail") {
                        
                        var failure: Bool? = nil
                        
                        beforeEach {
                            _ = session.rxDownloadRequest(errorRequest)
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
}
