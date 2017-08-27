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
                let body = BodyPdf(pdfData: data)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.pdf
                    expect(body.makeData()).toNot(beNil())
                }
            }
        }
        
        describe("BodyJSON") {
            
            context("when testing JSON") {
                
                let object = TestJSON(text: "Test")
                let body = BodyJSON(object: object)
                
                it("should have valid data") {
                    expect(body.contentType) == URLRequest.ContentType.json
                    expect(body.makeData()).toNot(beNil())
                }
            }
        }
        
        describe("BodyXML") {
            
            context("when testing XML") {
                
                it("should have valid data") {
                    // TODO
                }
            }
        }
        
        describe("BodyGraphQL") {
            
            context("when testing GraphQL") {
                
                it("should have valid data") {
                    // TODO
                }
            }
        }
        
        describe("BodyEncodedString") {
            
            context("when testing EncodedString") {
                
                let body = BodyEncodedString(encoding: .utf8, string: "Test")
                
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
