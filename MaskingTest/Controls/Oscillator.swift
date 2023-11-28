
import Foundation

class Oscillator {
    
    enum StartDirection {
        case up
        case down
    }
    
    init(minValue: Double = 0.0, maxValue: Double, startDirection: StartDirection = .up, period: TimeInterval) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.startDirection = startDirection
        self.period = period
    }
    
    var minValue: Double = 0.0
    var maxValue: Double
    var startDirection: StartDirection
    var period: TimeInterval
    
    private func sineEaseInOutUpDown(_ t: Double) -> Double {
//        return 0.5 - cos(t * .pi) * 0.5
//        \sin\left(\pi\left(x-0.5\right)\right)+1
        return 1.0 - (0.5 * cos(2 * .pi * t) + 0.5)
    }

    func oscillate(timeInterval: TimeInterval) -> Double {
        // Normalize the time interval to be within the range [0, 1]
        var normalizedTime = (timeInterval.truncatingRemainder(dividingBy: period)) / period

        // If starting in the down direction, adjust the phase
        if startDirection == .down {
            normalizedTime = 1.0 - normalizedTime
        }

        // Use the sine wave with ease-in and ease-out effect
//        let easedValue = minValue + (maxValue - minValue) * sineEaseInOutUpDown(normalizedTime)

        // Add a modulation to make it go up and down between minValue and maxValue
        let oscillation = minValue + (maxValue - minValue) * sineEaseInOutUpDown(normalizedTime)
//        print("timeInterval: \(timeInterval), normalized: \(normalizedTime), oscillation: \(oscillation)")

        return oscillation
    }
    
}
