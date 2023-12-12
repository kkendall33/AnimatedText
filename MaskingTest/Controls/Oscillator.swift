
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
        return 1.0 - (0.5 * cos(2 * .pi * t) + 0.5)
    }

    func oscillate(timeInterval: TimeInterval) -> Double {
        var normalizedTime = (timeInterval.truncatingRemainder(dividingBy: period)) / period
        if startDirection == .down {
            normalizedTime = 1.0 - normalizedTime
        }
        let oscillation = minValue + (maxValue - minValue) * sineEaseInOutUpDown(normalizedTime)
        return oscillation
    }
}
