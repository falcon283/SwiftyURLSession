//
//  URLRequestSpecs.swift
//  SwiftyURLSessionTests
//
//  Created by FaLcON2 on 24/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SwiftyURLSessionImp

class URLRequestSpecs : QuickSpec {
    
    override func spec() {
        
        describe("URLRequestSpecs") {
            
            context("when creating a simple request") {
                
                let request = try! Request(for: TestResource.self, object: TestResource.self)
                
                it("should have default parameters") {
                    expect(request.urlRequest.httpMethod?.lowercased()) == "get"
                }

                it("should have Accept header") {
                    expect(request.urlRequest.allHTTPHeaderFields?["Accept"]) == "application/json"
                }
            }
            
            context("when return data is not needed") {
                
                let request = try! Request(for: TestResource.self, object: TestResource.self, parseData: false)
                
                it("should have Accept header") {
                    expect(request.urlRequest.allHTTPHeaderFields?["Accept"]).to(beNil())
                }
            }
            
            context("when expecting return data") {
                
                let request = try! Request(for: TestResource.self, object: TestResource.self)
                
                it("should have Accept header") {
                    expect(request.urlRequest.allHTTPHeaderFields?["Accept"]) == "application/json"
                }
            }
            
            context("when creating a complex request") {
                
                context("with basic authentication") {
                    
                    let user = "user"
                    let password = "secret"
                    let request = try! Request(for: TestResource.self, object: TestResource.self, authentication: .basic(username: user, password: password))
    
                    it("should have Basic Authorization") {
                        
                        let utf8 = "\(user):\(password)".data(using: .utf8)
                        let base64 = utf8?.base64EncodedString()
                        let secret = base64.flatMap { "Basic \($0)" }
                        
                        expect(request.urlRequest.allHTTPHeaderFields?["Authentication"]) == secret
                    }
                }
                
                context("with oauth authentication") {
                    
                    let name = "Barer"
                    let secret = "secret"
                    let request = try! Request(for: TestResource.self, object: TestResource.self, authentication: URLRequest.Authentication.oauth2(name: name, secret: secret))
                    
                    it("should have OAuth Authorization") {
                        
                        expect(request.urlRequest.allHTTPHeaderFields?["Authentication"]) == "\(name) \(secret)"
                    }
                }
            }
            
            context("when changing method") {
                
                context("to post") {
                    
                    let request = try! Request(for: TestResource.self, object: TestResource.self, method: .post)
                    
                    it("should have post method") {
                        expect(request.urlRequest.httpMethod?.lowercased()) == "post"
                    }
                }
                
                context("to put") {
                    
                    let request = try! Request(for: TestResource.self, object: TestResource.self, method: .put)
                    
                    it("should have post method") {
                        expect(request.urlRequest.httpMethod?.lowercased()) == "put"
                    }
                }
                
                context("to patch") {
                    
                    let request = try! Request(for: TestResource.self, object: TestResource.self, method: .patch)
                    
                    it("should have post method") {
                        expect(request.urlRequest.httpMethod?.lowercased()) == "patch"
                    }
                }
                
                context("to delete") {
                    
                    let request = try! Request(for: TestResource.self, object: TestResource.self, method: .delete)
                    
                    it("should have post method") {
                        expect(request.urlRequest.httpMethod?.lowercased()) == "delete"
                    }
                }
            }
            
            context("when using options") {
                
                struct TestQuery : Query {
                    let test1: Bool
                    let test2: String
                    let test3: Int

                    var parameters: [String : String] {
                        return ["test1" : "\(test1)", "test2" : "\(test2)", "test3" : "\(test3)"]
                    }
                }
                
                let request = try! Request(for: TestResource.self, object: TestResource.self, query: TestQuery(test1: true, test2: "Test", test3: 5))
                
                it("should have post method") {
                    expect(request.urlRequest.url?.absoluteString) == "\(try! TestResource.url())?test1=true&test2=Test&test3=5"
                    expect(request.urlRequest.url?.query) == "test1=true&test2=Test&test3=5"
                }
            }

            context("when using placeholder") {

                context("properly") {

                    let request = try! Request(for: TestDynamicResource.self, object: TestDynamicResource.self, placeholders:["1234"])

                    it("url should contain placeholder") {
                        expect(request.urlRequest.url?.absoluteString).to(contain("1234"))
                    }
                }
            }
            
            context("when body") {
                
                context("is valid") {
                    
                    let body = MockBody(returnData: true, contentType: .json)
                    let request = try! Request(for: TestResource.self, object: TestResource.self, body: body)
                    
                    it("should have valid httpBody") {
                        expect(request.urlRequest.httpBody) == body.makeData()
                        expect(request.urlRequest.allHTTPHeaderFields?["Content-Type"]) == "application/json"
                    }
                }
                
                context("binary is invalid") {
                    
                    let body = MockBody(returnData: false, contentType: .binary)
                    
                    it("should throw invalidBinary") {
                        expect{ try Request(for: TestResource.self, object: TestResource.self, body: body) }
                            .to(throwError(URLRequest.RequestError.invalidBody(encodeError: .invalidBinary)))
                    }
                }
                
                context("graphql is invalid") {
                    
                    let body = MockBody(returnData: false, contentType: .graphql)
                    
                    it("should throw invalidGraphQL") {
                        expect{ try Request(for: TestResource.self, object: TestResource.self, body: body) }
                            .to(throwError(URLRequest.RequestError.invalidBody(encodeError: .invalidGraphQL)))
                    }
                }
                
                context("jpeg is invalid") {
                    
                    let body = MockBody(returnData: false, contentType: .jpeg)
                    
                    it("should throw invalidJPEG") {
                        expect{ try Request(for: TestResource.self, object: TestResource.self, body: body) }
                            .to(throwError(URLRequest.RequestError.invalidBody(encodeError: .invalidJPEG)))
                    }
                }
                
                context("json is invalid") {
                    
                    let body = MockBody(returnData: false, contentType: .json)
                    
                    it("should throw invalidJSON") {
                        expect{ try Request(for: TestResource.self, object: TestResource.self, body: body) }
                            .to(throwError(URLRequest.RequestError.invalidBody(encodeError: .invalidJSON)))
                    }
                }
                
                context("png is invalid") {
                    
                    let body = MockBody(returnData: false, contentType: .png)
                    
                    it("should throw invalidPNG") {
                        expect{ try Request(for: TestResource.self, object: TestResource.self, body: body) }
                            .to(throwError(URLRequest.RequestError.invalidBody(encodeError: .invalidPNG)))
                    }
                }
                
                context("pdf is invalid") {
                    
                    let body = MockBody(returnData: false, contentType: .pdf)
                    
                    it("should throw invalidPDF") {
                        expect{ try Request(for: TestResource.self, object: TestResource.self, body: body) }
                            .to(throwError(URLRequest.RequestError.invalidBody(encodeError: .invalidPDF)))
                    }
                }
                
                context("string is invalid") {
                    
                    let body = MockBody(returnData: false, contentType: .text)
                    
                    it("should throw invalidString") {
                        expect{ try Request(for: TestResource.self, object: TestResource.self, body: body) }
                            .to(throwError(URLRequest.RequestError.invalidBody(encodeError: .invalidString)))
                    }
                }
                
                context("xml is invalid") {
                    
                    let body = MockBody(returnData: false, contentType: .xml)
                    
                    it("should throw invalidXML") {
                        expect{ try Request(for: TestResource.self, object: TestResource.self, body: body) }
                            .to(throwError(URLRequest.RequestError.invalidBody(encodeError: .invalidXML)))
                    }
                }
                
                context("zip is invalid") {
                    
                    let body = MockBody(returnData: false, contentType: .zip)
                    
                    it("should throw invalidZIP") {
                        expect{ try Request(for: TestResource.self, object: TestResource.self, body: body) }
                            .to(throwError(URLRequest.RequestError.invalidBody(encodeError: .invalidZIP)))
                    }
                }
            }
            
            context("when using headers") {
                
                let request = try! Request(for: TestResource.self, object: TestResource.self, headers: ["a" : "b"])
                
                it("should have valid accept header") {
                    expect(request.urlRequest.allHTTPHeaderFields?["a"]) == "b"
                }
            }
            
            context("when using overlapping headers") {
                
                let body = MockBody(returnData: true, contentType: .xml)
                let headers = ["Accept" : "application/jpg",
                               "Content-Type" : "application/text",
                               "Authentication" : "TestAuth",
                               "test-header" : "test"]
                
                let request = try! Request(for: TestResource.self,
                                           object: TestResource.self,
                                           authentication: .oauth2(name: "oauth", secret: "secret"),
                                           headers: headers,
                                           body: body)
                
                it("should have header overriden") {
                    expect(request.urlRequest.allHTTPHeaderFields?["Accept"]) == "application/json"
                    expect(request.urlRequest.allHTTPHeaderFields?["Content-Type"]) == "application/xml"
                    expect(request.urlRequest.allHTTPHeaderFields?["Authentication"]) == "oauth secret"
                    expect(request.urlRequest.allHTTPHeaderFields?["test-header"]) == "test"
                }
            }
        }
    }
}
