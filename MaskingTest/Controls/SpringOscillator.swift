
import Foundation
import enum Accelerate.vDSP
import SwiftUI

struct AnimatableVector: VectorArithmetic {
    static var zero = AnimatableVector(values: [0.0])

    static func + (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = min(lhs.values.count, rhs.values.count)
        return AnimatableVector(values: vDSP.add(lhs.values[0..<count], rhs.values[0..<count]))
    }

    static func += (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = min(lhs.values.count, rhs.values.count)
        vDSP.add(lhs.values[0..<count], rhs.values[0..<count], result: &lhs.values[0..<count])
    }

    static func - (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = min(lhs.values.count, rhs.values.count)
        return AnimatableVector(values: vDSP.subtract(lhs.values[0..<count], rhs.values[0..<count]))
    }

    static func -= (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = min(lhs.values.count, rhs.values.count)
        vDSP.subtract(lhs.values[0..<count], rhs.values[0..<count], result: &lhs.values[0..<count])
    }

    var values: [Double]

    mutating func scale(by rhs: Double) {
        values = vDSP.multiply(rhs, values)
    }

    var magnitudeSquared: Double {
        vDSP.sum(vDSP.multiply(values, values))
    }
}

class SpringOscillator {

    enum StartDirection {
        case positive
        case negative
    }

    init(maxValue: Double, dampener: Double, startDirection: StartDirection = .positive, period: TimeInterval) {
        self.dampener = dampener
        self.maxValue = maxValue
        self.startDirection = startDirection
        self.period = period
    }

    var dampener: Double
    var maxValue: Double
    var startDirection: StartDirection
    var period: TimeInterval
    private var initialVelocity: Double = 0.0
    
    func oscillate(timeInterval: TimeInterval) -> Double {
        let s = Spring(duration: 0.7, bounce: 0.5)
        return s.value(target: AnimatableVector(values: [1]), time: timeInterval).values.first ?? 0
    }
    
    func constantPeriodFunction(time: TimeInterval, amplitude: Double, dampingRate: Double, frequency: Double, constant: Double) -> Double {
        let exponent = -dampingRate * time
        return amplitude * pow(M_E, exponent) * cos(2.0 * .pi * frequency * time) + constant
    }
    
    /* s+A⋅ e^−dt ⋅ cos(2πft)
     
     Where:

     s is the initial displacement on the y-axis,
     
     A is the amplitude of the oscillation,
     
     d is the damping rate,
     
     f is the frequency of the oscillation,
     
     t is time.
     
     
     mass stiffness and damping srping animation
     
     Apple
     A * cos(a*t+b)
     e^-c*t
     
     ChatGPT
     A⋅e
     −dt
      ⋅cos(2πft+ϕ)
     
     */
    
    func periodShorteningFunction(time: TimeInterval, amplitude: Double, dampingRate: Double, initialFrequency: Double, frequencyDampener: Double, constant: Double) -> Double {
        let frequency = initialFrequency + frequencyDampener * time
        let exponent = -dampingRate * time
        return amplitude * pow(M_E, exponent) * cos(2.0 * .pi * frequency * time) + constant
    }
    
    func springOscillationFunction(time: TimeInterval, amplitude: Double, dampingRate: Double, initialFrequency: Double, alpha: Double, targetConstant: Double) -> Double {
        let frequency = initialFrequency + alpha * time
        let exponent = -dampingRate * time
        return targetConstant + amplitude * pow(M_E, exponent) * cos(2.0 * .pi * frequency * time) - amplitude
    }

    func periodShorteningFunctionStartingAtZero(time: TimeInterval, amplitude: Double, dampingRate: Double, initialFrequency: Double, alpha: Double, constant: Double) -> Double {
        let frequency = initialFrequency + alpha * time
        let shiftedTime = time - time.truncatingRemainder(dividingBy: (1.0 / frequency))
        let exponent = -dampingRate * shiftedTime
        return amplitude * pow(M_E, exponent) * cos(2.0 * .pi * frequency * shiftedTime) + constant
    }
    
//    // Example usage:
//    let amplitude1 = 1.0
//    let dampingRate1 = 0.1
//    let initialFrequency1 = 1.0
//    let alpha1 = 0.1
//    let constant1 = 0.0
//
//    for time in stride(from: 0.0, through: 10.0, by: 1.0) {
//        let result = periodShorteningFunction(time: time, amplitude: amplitude1, dampingRate: dampingRate1, initialFrequency: initialFrequency1, alpha: alpha1, constant: constant1)
//        print("Time: \(time), Value: \(result)")
//    }


    
}


