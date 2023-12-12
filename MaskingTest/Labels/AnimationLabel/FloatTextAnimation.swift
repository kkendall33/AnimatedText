
import Foundation
import GameplayKit


struct FloatTextAnimation: TextAnimationProtocol {
    var totalCharacters: Int = 0
    var totalWords: Int = 0
    var animationDuration: TimeInterval {
        didSet {
            self.floatTransforms = updateTransformCache()
            self.floatTransforms = updateTransformCache()
        }
    }
    
    init(totalCharacters: Int = 0, totalWords: Int = 0, animationDuration: TimeInterval, granularity: AnimationGranularity = .word, wordOffset: TimeInterval = 0.6, wordAnimationDuration: TimeInterval = 1.3, floatTransforms: [Int : FloatTransform] = [:]) {
        self.totalCharacters = totalCharacters
        self.totalWords = totalWords
        self.animationDuration = animationDuration
        self.granularity = granularity
        self.wordOffset = wordOffset
        self.wordAnimationDuration = wordAnimationDuration
        self.floatTransforms = floatTransforms
    }
    
    var granularity: AnimationGranularity = .word
    
    var wordOffset: TimeInterval = 0.6
    var wordAnimationDuration: TimeInterval = 1.3
    
    private let pivot: TransformPivot = TransformPivot(pivotPoint: CGPoint(x: 0.5, y: 0.5))
    private let randomSource = GKRandomSource.sharedRandom()
    private var floatTransforms: [Int:FloatTransform] = [:]
    
    func wordTransform(playbackTime: Double, wordIndex: Int, characterWidth: Double, characterHeight: Double) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        transform = pivot.transformForPivotPoint(width: characterWidth, height: characterHeight) { transform in
            let index = Int(playbackTime * 1_000)
            let ft = self.floatTransforms[index] ?? FloatTransform(x: 0.0, y: 0.0, angle: 0.0)
//            print("ft: \(ft)")
            return transform.translatedBy(x: ft.x, y: ft.y).rotated(by: ft.angle)
        }
        return transform
    }
    
    private func updateTransformCache() -> [Int:FloatTransform] {
        let capacity = Int(animationDuration * 1000)
        var transforms = [Int:FloatTransform]()
        var prevTransform: FloatTransform = FloatTransform(x: 0, y: 0, angle: 0)
        
        var nextTimeIntervalIndexTargetX: Int = Int.random(in: 500..<2_000)
        var nextValTargetX: Double = Double.random(in: -20.0..<20.0)
        var xAddend = nextValTargetX / Double(nextTimeIntervalIndexTargetX) * (nextValTargetX > 0.0 ? 1.0 : -1.0)
        
        var nextTimeIntervalIndexTargetY: Int = Int.random(in: 500..<2_000)
        var nextValTargetY: Double = Double.random(in: -20.0..<20.0)
        var yAddend = nextValTargetY / Double(nextTimeIntervalIndexTargetY) * (nextValTargetY > 0.0 ? 1.0 : -1.0)
        
        var nextTimeIntervalIndexTargetAngle: Int = Int.random(in: 500..<2_000)
        var nextValTargetAngle: CGFloat = CGFloat.random(in: -15.degreesToRadians..<15.degreesToRadians)
        var angleAddend = nextValTargetAngle / CGFloat(nextTimeIntervalIndexTargetAngle) * (nextValTargetAngle > 0.0 ? 1.0 : -1.0)
        
        for i in 0..<capacity {
            let new = FloatTransform(x: prevTransform.x+xAddend, y: prevTransform.y+yAddend, angle: prevTransform.angle+angleAddend)
            transforms[i] = new
            prevTransform = new
            
            if i == nextTimeIntervalIndexTargetX {
                nextTimeIntervalIndexTargetX += Int.random(in: 500..<2_000)
                let prevValTargetX = nextValTargetX
                nextValTargetX = Double.random(in: -50..<50.0)
                xAddend = abs(nextValTargetX - prevValTargetX) / Double(nextTimeIntervalIndexTargetX) * (nextValTargetX > prevValTargetX ? 1.0 : -1.0)
//                print("xAddend: \(xAddend)")
            }
            if i == nextTimeIntervalIndexTargetY {
//                nextTimeIntervalIndexTargetY += Int.random(in: 500..<2_000)
                nextTimeIntervalIndexTargetY = 2000
                let prevValTargetY = nextValTargetY
//                nextValTargetY = Double.random(in: -200.0..<200.0)
                nextValTargetY = Bool.random() ? 200 : -200
                yAddend = abs(nextValTargetY - prevValTargetY) / Double(nextTimeIntervalIndexTargetY) * (nextValTargetY > prevValTargetY ? 1.0 : -1.0)
                print("yAddend: \(yAddend), prevValTargetY: \(prevValTargetY), nextValTargetY: \(nextValTargetY), nextTimeIntervalIndexTargetY: \(nextTimeIntervalIndexTargetY)")
            }
            if i == nextTimeIntervalIndexTargetAngle {
                nextTimeIntervalIndexTargetAngle += Int.random(in: 500..<2_000)
                let prevValTargetAngle = nextValTargetAngle
                nextValTargetAngle = CGFloat.random(in: -15.degreesToRadians..<0.degreesToRadians)
                angleAddend = abs(nextValTargetAngle - prevValTargetAngle) / CGFloat(nextTimeIntervalIndexTargetAngle) * (nextValTargetAngle > prevValTargetAngle ? 1.0 : -1.0)
//                print("angleAddend: \(angleAddend)")
            }
        }
        return transforms
    }
    
}

extension CGFloat {
    var degreesToRadians: CGFloat {
        self * .pi / 180.0
    }
}

struct FloatTransform: Hashable {
    let x: Double
    let y: Double
    let angle: CGFloat
}
