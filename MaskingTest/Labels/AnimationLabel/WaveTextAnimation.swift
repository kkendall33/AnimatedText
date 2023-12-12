
import Foundation

struct WaveTextAnimation: TextAnimationProtocol {
    var totalCharacters: Int = 0
    var totalWords: Int = 0
    var animationDuration: TimeInterval
    
    var granularity: AnimationGranularity = .character
    
    var characterTimeOffset: TimeInterval = 0.1
    
    var oscillator: Oscillator = Oscillator(minValue: -30, maxValue: 30, startDirection: .up, period: 1.5)
    
    func translation(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int) -> CGPoint {
        let offset = CGFloat(characterIndex) * characterTimeOffset
        let yValue = oscillator.oscillate(timeInterval: playbackTime - offset)
        return CGPoint(x: 0, y: yValue)
    }
}
