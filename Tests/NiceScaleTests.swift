//
// NiceScaleTests.swift
//  
// Copyright 2021 FlowAllocator LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

import XCTest

@testable import NiceScale

class NiceScaleTests: XCTestCase {
    
    typealias NS = NiceScale<Double>
    
    func testExample() {
        let ns = NiceScale(105...543, desiredTicks: 5)!
        XCTAssertEqual(0, ns.tickFractionDigits)
        XCTAssertEqual(100, ns.tickInterval)
        XCTAssertEqual(100.0...600.0, ns.range)
        //print("nice range=\(ns.range)")
        //print("tick interval=\(ns.tickInterval)")
        //print("labels=\(ns.tickValues)")
    }

    func testFractionDigits() {
        let ns20 = NS(1...4, desiredTicks: 20)!
        XCTAssertEqual(1, ns20.tickFractionDigits)

        let ns200 = NS(1...4, desiredTicks: 200)!
        XCTAssertEqual(2, ns200.tickFractionDigits)
    }
    
    func testBadInit() {
        let ns0 = NS(0...0)
        XCTAssertNil(ns0)
        
        let ns1 = NS(1...1)
        XCTAssertNil(ns1)
        
        let ns2 = NS(0...1, desiredTicks: 0)
        XCTAssertNil(ns2)
        
        let ns3 = NS(0...1, desiredTicks: 1)
        XCTAssertNil(ns3)
    }
    
    func testPositiveRange() {
        let ns = NS(10...100)!
        XCTAssertTrue(ns.hasPositiveRange)
        XCTAssertFalse(ns.hasNegativeRange)
        XCTAssertEqual(10...100, ns.positiveRange)
        XCTAssertEqual(0...0, ns.negativeRange)
        XCTAssertEqual(90, ns.positiveExtent)
        XCTAssertEqual(0, ns.negativeExtent)
        
        XCTAssertEqual(0.25, ns.scaleToUnit(32.5))
        XCTAssertEqual(0.25, ns.scaleToUnitPositive(32.5))
        XCTAssertEqual(-Double.infinity, ns.scaleToUnitNegative(32.5))
    }
    
    func testNegativeRange() {
        let ns = NS(-100...(-10))!
        XCTAssertFalse(ns.hasPositiveRange)
        XCTAssertTrue(ns.hasNegativeRange)
        XCTAssertEqual(0...0, ns.positiveRange)
        XCTAssertEqual(-100...(-10), ns.negativeRange)
        XCTAssertEqual(0, ns.positiveExtent)
        XCTAssertEqual(90, ns.negativeExtent)
        
        XCTAssertEqual(0.75, ns.scaleToUnit(-32.5))
        XCTAssertEqual(-Double.infinity, ns.scaleToUnitPositive(-32.5))
        XCTAssertEqual(0.25, ns.scaleToUnitNegative(-32.5))
    }
    
    func testBothRange() {
        let ns = NS(-100...100)!
        XCTAssertTrue(ns.hasPositiveRange)
        XCTAssertTrue(ns.hasNegativeRange)
        XCTAssertEqual(0...100, ns.positiveRange)
        XCTAssertEqual((-100)...0, ns.negativeRange)
        XCTAssertEqual(100, ns.positiveExtent)
        XCTAssertEqual(100, ns.negativeExtent)
        
        XCTAssertEqual(0.75, ns.scaleToUnit(50))
        XCTAssertEqual(0.5, ns.scaleToUnitPositive(50))
        XCTAssertEqual(-0.5, ns.scaleToUnitNegative(50)) //??
        XCTAssertEqual(0.25, ns.scaleToUnit(-50))
        XCTAssertEqual(-0.5, ns.scaleToUnitPositive(-50)) //??
        XCTAssertEqual(0.5, ns.scaleToUnitNegative(-50))
    }
    
}
