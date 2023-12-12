
import Foundation


struct PopTextAnimation: TextAnimationProtocol {
    var totalCharacters: Int = 0
    var totalWords: Int = 0
    var animationDuration: TimeInterval
    
    var granularity: AnimationGranularity = .character
    
    var wordOffset: TimeInterval = 0.6
    var wordAnimationDuration: TimeInterval = 1.3
    
    private let pivot: TransformPivot = TransformPivot(pivotPoint: CGPoint(x: 0.5, y: 0.5))
    
    var springOscillator: SpringOscillator = SpringOscillator(maxValue: 1.5, dampener: 1.5, startDirection: .positive, period: 3.5)
    
//    func translation(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int) -> CGPoint {
//        let offset = CGFloat(characterIndex) * characterTimeOffset
//        let yValue = oscillator.oscillate(timeInterval: playbackTime - offset)
//        return CGPoint(x: 0, y: yValue)
//    }
    
    func wordTransform(playbackTime: Double, wordIndex: Int, characterWidth: Double, characterHeight: Double) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        
        transform = pivot.transformForPivotPoint(width: characterWidth, height: characterHeight) { transform in
            let val = playbackTime - (wordOffset * CGFloat(wordIndex))
            if val < 0 {
                let scaleValue = 0.0
                return transform.scaledBy(x: scaleValue, y: scaleValue)
            } else {
                let scaleValue = springOscillator.oscillate(timeInterval: val)
                return transform.scaledBy(x: scaleValue, y: scaleValue)
            }
        }
        
        return transform
    }
    
}

struct TransformPivot {
    
    let pivotPoint: CGPoint
    
    private func xPivotPoint(width: CGFloat) -> CGFloat {
        return width * pivotPoint.x
    }
    
    private func yPivotPoint(height: CGFloat) -> CGFloat {
        return height * pivotPoint.y
    }
    
    func transformForPivotPoint(width: CGFloat, height: CGFloat, transformBlock: (_ transform: CGAffineTransform) -> CGAffineTransform) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        transform = self.transformWithPivotPointAdded(transform: transform, width: width, height: height)
        transform = transformBlock(transform)
        transform = self.transformWithPivotPointRemoved(transform: transform, width: width, height: height)
        return transform
    }
    
    func transformWithPivotPointAdded(transform: CGAffineTransform, width: CGFloat, height: CGFloat) -> CGAffineTransform {
        return transform.translatedBy(x: xPivotPoint(width: width), y: yPivotPoint(height: height))
    }
    
    func transformWithPivotPointRemoved(transform: CGAffineTransform, width: CGFloat, height: CGFloat) -> CGAffineTransform {
        return transform.translatedBy(x: -xPivotPoint(width: width), y: -yPivotPoint(height: height))
    }
    
}
