//
//  URLRequestSpecs.swift
//  SwiftyNetworkTests
//
//  Created by FaLcON2 on 24/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SwiftyNetwork

class URLRequestSpecs : QuickSpec {
    
    override func spec() {
        
        describe("URLRequestSpecs") {
            
            context("when creating a simple request") {
                
                let request = try! URLRequest(for: TestResource.self)
                
                it("should have default parameters") {
                    expect(request.httpMethod?.lowercased()) == "get"
                    expect(request.allHTTPHeaderFields).to(beEmpty())
                }
            }
            
            context("when creating a complex request") {
                
                context("with basic authentication") {
                    
                    let user = "user"
                    let password = "secret"
                    let request = try! URLRequest(for: TestResource.self, authentication: .basic(username: user, password: password))
    
                    it("should have Basic Authorization") {
                        
                        let utf8 = "\(user):\(password)".data(using: .utf8)
                        let base64 = utf8?.base64EncodedString()
                        let secret = base64.flatMap { "Basic \($0)" }
                        
                        expect(request.allHTTPHeaderFields?["Authentication"]) == secret
                    }
                }
                
                context("with oauth authentication") {
                    
                    let name = "Barer"
                    let secret = "secret"
                    let request = try! URLRequest(for: TestResource.self, authentication: URLRequest.Authentication.oauth2(name: name, secret: secret))
                    
                    it("should have OAuth Authorization") {
                        
                        expect(request.allHTTPHeaderFields?["Authentication"]) == "\(name) \(secret)"
                    }
                }
            }
            
            context("when changing method") {
                
                context("to post") {
                    
                    let request = try! URLRequest(for: TestResource.self, method: .post)
                    
                    it("should have post method") {
                        expect(request.httpMethod?.lowercased()) == "post"
                    }
                }
                
                context("to put") {
                    
                    let request = try! URLRequest(for: TestResource.self, method: .put)
                    
                    it("should have post method") {
                        expect(request.httpMethod?.lowercased()) == "put"
                    }
                }
                
                context("to patch") {
                    
                    let request = try! URLRequest(for: TestResource.self, method: .patch)
                    
                    it("should have post method") {
                        expect(request.httpMethod?.lowercased()) == "patch"
                    }
                }
                
                context("to delete") {
                    
                    let request = try! URLRequest(for: TestResource.self, method: .delete)
                    
                    it("should have post method") {
                        expect(request.httpMethod?.lowercased()) == "delete"
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
                
                let request = try! URLRequest(for: TestResource.self, query: TestQuery(test1: true, test2: "Test", test3: 5))
                
                it("should have post method") {
                    expect(request.url?.absoluteString) == "\(TestResource.url!)?test1=true&test2=Test&test3=5"
                    expect(request.url?.query) == "test1=true&test2=Test&test3=5"
                }
            }
            
            context("when using body") {
                
                let body = BodyJSON(object: TestJSON(text: "Test"))
                let request = try! URLRequest(for: TestResource.self, body: body)
                
                it("should have valid httpBody") {
                    expect(request.httpBody) == body.makeData()
                    expect(request.allHTTPHeaderFields?["Content-Type"]) == "application/json"
                }
            }
            
            context("when using headers") {
                
                let request = try! URLRequest(for: TestResource.self, headers: ["a" : "b"])
                
                it("should have valid accept header") {
                    expect(request.allHTTPHeaderFields?["a"]) == "b"
                }
            }
            
            context("when using overlapping headers") {
                
                let body = BodyJSON(object: TestJSON(text: "Test"))
                let request = try! URLRequest(for: TestResource.self,
                                              authentication: .oauth2(name: "oauth", secret: "secret"),
                                              body: body,
                                              accepting: .png,
                                              headers: ["Accept" : "application/jpg",
                                                        "Content-Type" : "application/text",
                                                        "Authentication" : "TestAuth",
                                                        "test-header" : "test"])
                
                it("should have header overriden") {
                    expect(request.allHTTPHeaderFields?["Accept"]) == "application/png"
                    expect(request.allHTTPHeaderFields?["Content-Type"]) == "application/json"
                    expect(request.allHTTPHeaderFields?["Authentication"]) == "oauth secret"
                    expect(request.allHTTPHeaderFields?["test-header"]) == "test"
                }
            }
            
            context("when expecting data") {
                
                let request = try! URLRequest(for: TestResource.self, accepting: .json)
                
                it("should have valid accept header") {
                    expect(request.allHTTPHeaderFields?["Accept"]) == "application/json"
                }
            }
        }
    }
}
