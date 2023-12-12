import Foundation

protocol TextAnimationProtocol {
    var totalCharacters: Int { get set }
    var totalWords: Int { get set }
    var animationDuration: TimeInterval { get set }
    var granularity: AnimationGranularity { get set }
    func translation(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int) -> CGPoint
    func characterTransform(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int, characterWidth: Double, characterHeight: Double) -> CGAffineTransform
    func wordTransform(playbackTime: Double, wordIndex: Int, characterWidth: Double, characterHeight: Double) -> CGAffineTransform
    func opacity(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int) -> CGFloat
}

extension TextAnimationProtocol {
    func translation(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int) -> CGPoint {
        .zero
    }
    func characterTransform(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int, characterWidth: Double, characterHeight: Double) -> CGAffineTransform {
        .identity
    }
    func wordTransform(playbackTime: Double, wordIndex: Int, characterWidth: Double, characterHeight: Double) -> CGAffineTransform {
        .identity
    }
    func opacity(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int) -> CGFloat {
        1.0
    }
}

enum AnimationGranularity {
    case character, word, full
}

struct TransformTextAnimation: TextAnimationProtocol {
    var totalCharacters: Int = 0
    var totalWords: Int = 0
    var animationDuration: TimeInterval
    
    var granularity: AnimationGranularity = .character
    
    var characterTimeOffset: TimeInterval = 0.1
    var rotationCharacterTimeOffset: TimeInterval = 0.5
    
    var oscillator: Oscillator = Oscillator(minValue: -30, maxValue: 30, startDirection: .up, period: 1.5)
    var rotationOscillator: Oscillator = Oscillator(minValue: -CGFloat.pi / 4, maxValue: CGFloat.pi / 4, startDirection: .up, period: 1.5)
    var scaleOscillator: Oscillator = Oscillator(minValue: 0.8, maxValue: 1.5, startDirection: .up, period: 3)
    
    func translation(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int) -> CGPoint {
//        return .zero
        let offsetMultiple: Double
        switch granularity {
        case .character:
            offsetMultiple = CGFloat(characterIndex)
        case .word:
            offsetMultiple = CGFloat(wordIndex)
        case .full:
            offsetMultiple = 0
        }
        let offset = offsetMultiple * characterTimeOffset
        let yValue = oscillator.oscillate(timeInterval: playbackTime - offset)
        return CGPoint(x: 0, y: yValue)
    }
    
    func characterTransform(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int, characterWidth: Double, characterHeight: Double) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: characterWidth/2, y: characterHeight/2)
        let offset = CGFloat(wordIndex) * rotationCharacterTimeOffset
        let rotationAngle = rotationOscillator.oscillate(timeInterval: offset + playbackTime)
//        transform = transform.rotated(by: rotationAngle)
        let scaleMultiple = scaleOscillator.oscillate(timeInterval: offset - playbackTime)
//        transform = transform.scaledBy(x: scaleMultiple, y: scaleMultiple)
        
        transform = transform.translatedBy(x: -characterWidth/2, y: -characterHeight/2)
        
        return transform
    }
    
    func wordTransform(playbackTime: Double, wordIndex: Int, characterWidth: Double, characterHeight: Double) -> CGAffineTransform {
//        return .identity
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: characterWidth/2, y: characterHeight/2)
        let offset = CGFloat(wordIndex) * rotationCharacterTimeOffset
        let rotationAngle = rotationOscillator.oscillate(timeInterval: offset + playbackTime)
        transform = transform.rotated(by: rotationAngle)
        transform = transform.translatedBy(x: -characterWidth/2, y: -characterHeight/2)
        return transform
    }
    
    func opacity(playbackTime: Double, characterIndex: Int, wordIndex: Int, characterIndexInWord: Int) -> CGFloat {
//        let fadeInDuration = 0.5
//        let elapsedTime = playbackTime + Double(characterIndex) * fadeInDuration
//        let opacity = CGFloat(max(0, min(1, elapsedTime / fadeInDuration)))
//        return opacity
        let characterFadeDuration = 0.2
        let currentAnimatingChar = CGFloat(characterIndex) * characterFadeDuration
        let timeInCharacterFade = max(min(playbackTime - currentAnimatingChar, 1.0), 0)
        return timeInCharacterFade
    }
    
}
