//
//  MaskingTestTests.swift
//  MaskingTestTests
//
//  Created by Kyle Kendall on 11/13/23.
//

import XCTest
import MaskingTest

final class RandomNumberTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIntegers() throws {
        let timeIntervals: [Double] = [1,2,3,4,5,6,7,8,9,10,]
        
        var results: [Double:Double] = [:]
        
        let rando = PredictableRandomNumberGenerator(minValue: 0, maxValue: 25, primarySeed: 1)
        
        for s in timeIntervals {
            results[s] = rando.randomNumber(timeInterval: s)
        }
        for s in timeIntervals {
            XCTAssert(results[s] == rando.randomNumber(timeInterval: s), "Number didn't line up")
        }
    }
    
    func testFloats() throws {
        let timeIntervals: [Double] = [1.2,2.36,4.5,6.7,3.6,4.1,43.5,7.89,90.7,5.3,1.4,5.7,8.9]
        
        var results: [Double:Double] = [:]
        
        let rando = PredictableRandomNumberGenerator(minValue: 0, maxValue: 25, primarySeed: 41)
        
        for s in timeIntervals {
            results[s] = rando.randomNumber(timeInterval: s)
        }
        for s in timeIntervals {
            XCTAssert(results[s] == rando.randomNumber(timeInterval: s), "Number didn't line up")
        }
    }
    
    func test2Instances() throws {
        let timeIntervals: [Double] = [1.2,2.36,4.5,6.7,3.6,4.1,43.5,7.89,90.7,5.3,1.4,5.7,8.9]
        
        let first = PredictableRandomNumberGenerator(minValue: 0.0, maxValue: 10000.0, primarySeed: 2)
        let second = PredictableRandomNumberGenerator(minValue: 0.0, maxValue: 10000.0, primarySeed: 4)
        
        var allSame = true
        
        for s in timeIntervals {
            if first.randomNumber(timeInterval: s) != second.randomNumber(timeInterval: s) {
                allSame = false
            }
        }
        
        XCTAssert(allSame == false, "All numbers were the same for two separate instances")
    }
    
    func testPerformanceCreation() {
        measure {
            _ = PredictableRandomNumberGenerator(minValue: 0.0, maxValue: 12.0, primarySeed: 5)
        }
    }
    
    func testPerformanceCreationAndRandom() {
        measure {
            let val = PredictableRandomNumberGenerator(minValue: 0.0, maxValue: 12.0, primarySeed: 6)
            _ = val.randomNumber(timeInterval: 2.3)
        }
    }
    
    func testPerformanceCreationAndRandomManyTimes() {
        measure {
            let val = PredictableRandomNumberGenerator(minValue: 0.0, maxValue: 12.0, primarySeed: 7)
            for _ in 0..<1_000_000 {
                _ = val.randomNumber(timeInterval: 2.3)
            }
        }
    }
    
    func testPerformanceCreationAndRandomManyTimeDifferentTimeIntervals() {
        var seeds: [Double] = []
        for _ in 0..<1_000_000 {
            seeds.append(Double.random(in: 0..<1000))
        }
        measure {
            let val = PredictableRandomNumberGenerator(minValue: 0.0, maxValue: 12.0, primarySeed: 8)
            for randomSeeds in seeds {
                _ = val.randomNumber(timeInterval: randomSeeds)
            }
        }
    }
    
    func testPerfCreateRandoGeneratorRandomMinMaxValues() {
        let max = 1_000_000
        var seeds: [Double] = []
        for _ in 0..<max {
            seeds.append(Double.random(in: 0..<1000))
        }
        var minValues: [Double] = []
        for _ in 0..<max {
            minValues.append(Double.random(in: -1000..<0))
        }
        var maxValues: [Double] = []
        for _ in 0..<max {
            maxValues.append(Double.random(in: 1..<1000))
        }
        measure {
            for i in 0..<max {
                let val = PredictableRandomNumberGenerator(minValue: minValues[i], maxValue: maxValues[i], primarySeed: 9)
                _ = val.randomNumber(timeInterval: seeds[i])
            }
        }
    }

}
