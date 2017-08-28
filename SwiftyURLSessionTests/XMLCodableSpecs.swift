//
//  XMLCodableSpecs.swift
//  SwiftyURLSessionTests
//
//  Created by FaLcON2 on 28/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import SwiftyURLSessionImp

class XMLCodableSpecs : QuickSpec {
    
    override func spec() {
        
        describe("XMLInLineEncoderSpecs") {
            
            context("when proper function is injected") {
                
                let encoder = XMLInLineEncoder<TestCodable>({ _ in return Data() })
                
                it("should return valid data") {
                    expect { try encoder.encode(TestCodable(text: "Test")) }.toNot(throwError())
                }
            }
            
            context("when wrong function is injected") {
                
                let encoder = XMLInLineEncoder<TestCodable>({ _ in return nil })
                
                it("should return valid data") {
                    expect { try encoder.encode(TestCodable(text: "Test")) }.to(throwError(XMLEncoderError.encodeError))
                }
            }
        }
        
        describe("XMLInLineDecoderSpecs") {
            
            context("when proper function is injected") {
                
                let decoder = XMLInLineDecoder<TestCodable>({ _ in return TestCodable(text: "Test") })
                
                it("should return valid data") {
                    expect { try decoder.decode(Data()) }.toNot(throwError())
                }
            }
            
            context("when wrong function is injected") {
                
                let decoder = XMLInLineDecoder<TestCodable>({ _ in return nil })
                
                it("should return valid data") {
                    expect { try decoder.decode(Data()) }.to(throwError(XMLDecoderError.decodeError))
                }
            }
        }
    }
}
