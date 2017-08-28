//
//  GraphQLCodableSpecs.swift
//  SwiftyURLSessionTests
//
//  Created by FaLcON2 on 28/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import SwiftyURLSessionImp

class GraphQLCodableSpecs : QuickSpec {
    
    override func spec() {
        
        describe("GraphQLInLineEncoderSpecs") {
            
            context("when proper function is injected") {
                
                let encoder = GraphQLInLineEncoder<TestCodable>({ (_, _, _) in return Data() })
                
                it("should return valid data") {
                    expect { try encoder.encode(TestCodable(text: "Test")) }.toNot(throwError())
                }
            }
            
            context("when wrong function is injected") {
                
                let encoder = GraphQLInLineEncoder<TestCodable>({ (_, _, _) in return nil })
                
                it("should return valid data") {
                    expect { try encoder.encode(TestCodable(text: "Test")) }.to(throwError(GraphQLEncoderError.encodeError))
                }
            }
        }
        
        describe("GraphQLInLineDecoderSpecs") {
            
            context("when proper function is injected") {
                
                let decoder = GraphQLInLineDecoder<TestCodable>({ _ in return TestCodable(text: "Test") })
                
                it("should return valid data") {
                    expect { try decoder.decode(Data()) }.toNot(throwError())
                }
            }
            
            context("when wrong function is injected") {
                
                let decoder = GraphQLInLineDecoder<TestCodable>({ _ in return nil })
                
                it("should return valid data") {
                    expect { try decoder.decode(Data()) }.to(throwError(GraphQLDecoderError.decodeError))
                }
            }
        }
        
        describe("GraphQLJSONDecoderSpecs") {
            
            context("when proper function is injected") {
                
                let decoder = GraphQLJSONDecoder<TestCodable>(decoder: JSONDecoder(), for: TestCodable.self)
                let data = try! JSONEncoder().encode(TestCodable(text: "Test"))
                
                it("should return valid data") {
                    expect { try decoder.decode(data) }.toNot(throwError())
                }
            }
            
            context("when wrong function is injected") {
                
                let decoder = GraphQLJSONDecoder<TestCodable>(decoder: JSONDecoder(), for: TestCodable.self)
                
                it("should return valid data") {
                    expect { try decoder.decode(Data()) }.to(throwError())
                }
            }
        }
    }
}
