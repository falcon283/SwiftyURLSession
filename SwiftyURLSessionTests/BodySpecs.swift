//
//  BodySpecs.swift
//  BodySpecs
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SwiftyURLSessionImp

class BodySpecs: QuickSpec {
    
    override func spec() {
        
        describe("BodyImage") {
            
            context("when testing jpeg") {
                let url = Bundle(for: BodySpecs.self).url(forResource: "kittenjpg", withExtension: "jpg")!
                let data = try! Data(contentsOf: url)
                let body = BodyImage.jpeg(image: UIImage(data: data)!, compression: 0.6)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.jpeg
                    expect(body.makeData()).toNot(beNil())
                }
            }
            
            context("when testing png") {
                let url = Bundle(for: BodySpecs.self).url(forResource: "kittenpng", withExtension: "png")!
                let data = try! Data(contentsOf: url)
                let body = BodyImage.png(image: UIImage(data: data)!)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.png
                    expect(body.makeData()).toNot(beNil())
                }
            }
            
            context("when testing binary") {
                let url = Bundle(for: BodySpecs.self).url(forResource: "kittenjpg", withExtension: "jpg")!
                let data = try! Data(contentsOf: url)
                let body = BodyImage.binary(data: data, contentType: .jpeg)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.jpeg
                    expect(body.makeData()).toNot(beNil())
                }
            }
        }
        
        describe("BodyPdf") {
            
            context("when testing pdf") {
                let url = Bundle(for: BodySpecs.self).url(forResource: "blank", withExtension: "pdf")!
                let data = try! Data(contentsOf: url)
                let body = BodyPdf(for: data)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.pdf
                    expect(body.makeData()).toNot(beNil())
                }
            }
        }
        
        describe("BodyJSON") {
            
            context("when testing JSON") {
                
                let object = TestCodable(text: "Test")
                let body = BodyJSON(for: object, with: JSONEncoder())
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.json
                    expect(body.makeData()).toNot(beNil())
                }
            }
        }
        
        describe("BodyGraphQL") {
            
            context("when GraphQL is encodable") {
                
                let object = TestCodable(text: "Test")
                let encoder = GraphQLInLineEncoder<TestCodable>({ (_, _, _) in Data() })
                let body = BodyGraphQL<GraphQLInLineEncoder<TestCodable>>(for: object, query: .query, with: encoder)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.graphql
                    expect(body.makeData()).toNot(beNil())
                }
            }
            
            context("when GraphQL is not encodable") {
                
                let object = TestCodable(text: "Test")
                let encoder = GraphQLInLineEncoder<TestCodable>({ (_, _, _) in nil })
                let body = BodyGraphQL<GraphQLInLineEncoder<TestCodable>>(for: object, query: .query, with: encoder)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.graphql
                    expect(body.makeData()).to(beNil())
                }
            }
        }
        
        describe("BodyXML") {
            
            context("when XML is encodable") {
                
                let object = TestCodable(text: "Test")
                let encoder = XMLInLineEncoder<TestCodable>({ (_) in Data() })
                let body = BodyXML<XMLInLineEncoder<TestCodable>>(for: object, with: encoder)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.xml
                    expect(body.makeData()).toNot(beNil())
                }
            }
            
            context("when XML is not encodable") {
                
                let object = TestCodable(text: "Test")
                let encoder = XMLInLineEncoder<TestCodable>({ (_) in nil })
                let body = BodyXML<XMLInLineEncoder<TestCodable>>(for: object, with: encoder)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.xml
                    expect(body.makeData()).to(beNil())
                }
            }
        }
        
        describe("BodyEncodedString") {
            
            context("when testing EncodedString") {
                
                let body = BodyEncodedString(for: "Test", in: .utf8)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.text
                    expect(body.makeData()).toNot(beNil())
                }
            }
        }
        
        describe("Data") {
            
            context("when testing Data") {
                
                let body = Data()
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.binary
                    expect(body.makeData()).toNot(beNil())
                }
            }
        }
    }
}
