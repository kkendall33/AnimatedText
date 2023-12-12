
import UIKit

class AnimatedLabel: UILabel {
    
    var neonOutlineRadius: Double? {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    private var textAnimation: TextAnimationProtocol = WaveTextAnimation(animationDuration: 60*2)
//    private var textAnimation: TextAnimationProtocol = PopTextAnimation(animationDuration: 0.0)
    private var textAnimation: TextAnimationProtocol = FloatTextAnimation(animationDuration: 0.0)
    
    var currentTime: TimeInterval = 0.0
    
    var animationDuration: TimeInterval = 0.0 {
        didSet {
            textAnimation.animationDuration = animationDuration
        }
    }
    
    var granularity: AnimationGranularity = .character {
        didSet {
            textAnimation.granularity = granularity
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
//        layer.addSublayer(outerShadowLayer)
    }
    
    override func drawText(in rect: CGRect) {
        
        textAnimation.totalCharacters = text?.count ?? 0
        textAnimation.totalWords = wordCount()
        drawEach(rect: rect)
        
//        outerShadowLayer.path = outerPath
//        if let neonOutlineRadius, neonOutlineRadius > 20 {
//            outerShadowLayer.shadowColor = UIColor.red.cgColor
//        } else {
//            outerShadowLayer.shadowColor = UIColor.yellow.cgColor
//        }
    }
    
//    private lazy var outerShadowLayer: CAShapeLayer = {
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.fillColor = nil
////         shapeLayer.strokeColor = nil
//        shapeLayer.strokeColor = UIColor.yellow.withAlphaComponent(0.2).cgColor
//         shapeLayer.lineWidth = 5
//         shapeLayer.path = UIBezierPath(rect: CGRect(x: 50, y: 50, width: 100, height: 100)).cgPath
//         shapeLayer.shadowColor = UIColor.yellow.cgColor
//         shapeLayer.shadowOffset = CGSize(width: 5, height: 5)
//         shapeLayer.shadowOpacity = 0.7
//         shapeLayer.shadowRadius = 5.0
//        
//        return shapeLayer
//    }()
//    
//    fileprivate var outerPath: CGPath = CGPath(rect: .zero, transform: nil)
    
}

extension AnimatedLabel {
    
    func wordCount() -> Int {
        let words = (text ?? "").components(separatedBy: .whitespacesAndNewlines)
        let filteredWords = words.filter { !$0.isEmpty }
        return filteredWords.count
    }
    
    func drawEach(rect: CGRect) {
        guard let attributedText = attributedText,
            let context = UIGraphicsGetCurrentContext() else { return }
        
        let mut = NSMutableAttributedString(attributedString: attributedText)
        let p = NSMutableParagraphStyle()
        p.alignment = self.textAlignment
        mut.addAttribute(.paragraphStyle, value: p, range: NSMakeRange(0, attributedText.length))

        context.textMatrix = .identity
        context.move(to: CGPoint(x: 30, y: 30))
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
//        context.move(to: CGPoint(x: 0, y: 30))
        
        context.setLineJoin(.round)

        let framesetter = CTFramesetterCreateWithAttributedString(mut.copy() as! NSAttributedString)
        let path = CGPath(rect: bounds, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedText.length), path, nil)

        guard let lines = CTFrameGetLines(frame) as? [CTLine] else { return }
        
        let ctFrameHeight = ctFrameHeight(ctFrame: frame)
        let ctFrameYOffset: CGFloat = (rect.height / 2) - (ctFrameHeight / 2)
        var currentLineYOffset: CGFloat = ctFrameYOffset

        context.saveGState()
        let frameStartPoint = (rect.height - ctFrameHeight)/2
        context.translateBy(x: 0, y: rect.height - frameStartPoint)
        var fullCharacterIndex = 0
        var wordIndex = 0
        var isPreviousCharacterSpaceOrNewLine = false
        var characterInWordIndex = 0
        var mutableWordPath = CGMutablePath()
        var mutableWordPathY = rect.height - frameStartPoint
        var mutableWordPathX = 0.0
        for (lineIndex, line) in lines.enumerated() {
            let glyphRuns = CTLineGetGlyphRuns(line) as! [CTRun]
            let linebounds = CTLineGetBoundsWithOptions(line, [])
            let lineWidth = linebounds.width
            let lineHeight = ctLineHeight(ctLine: line)
            
            let mutableStrokePath = lineCGPath(ctLine: line)
            
            var entireCGPath = CGMutablePath()
            var prevX: CGFloat = 0.0
            let textCenter = rect.height/2
//                let totalTextHeight
            
            context.translateBy(x: 0, y: -lineHeight)
            mutableWordPathY -= lineHeight
            context.saveGState()
            for run in glyphRuns {
                let glyphCount = CTRunGetGlyphCount(run)
//                context.saveGState()
                
                context.apply(attributes: CTRunGetAttributes(run) as! [NSAttributedString.Key : Any])
                let paragraphStyle = CTRunGetAttributes(run) as? [NSAttributedString.Key: Any]
                let alignment = (paragraphStyle?[.paragraphStyle] as? NSParagraphStyle)?.alignment ?? .left
                
//                defer {
//                    context.restoreGState()
//                }
                var str = ""
                var timesDrawn = 0
                for glyphIndex in 0..<glyphCount {
                    let glyphRange = CFRangeMake(glyphIndex, 1)
                    var glyphPosition = CGPoint.zero
                    CTRunGetPositions(run, glyphRange, &glyphPosition)

                    var glyphAscent: CGFloat = 0
                    var glyphDescent: CGFloat = 0
                    let glyphWidth = CGFloat(CTRunGetTypographicBounds(run, glyphRange, &glyphAscent, &glyphDescent, nil))

                    var alignmentOffset: CGFloat = 0.0

                    switch alignment {
                    case .left:
                        alignmentOffset = 0.0
                    case .center:
                        alignmentOffset = (rect.width / 2.0) - (lineWidth / 2.0)
                    case .right:
                        alignmentOffset = rect.width - lineWidth
                    default:
                        alignmentOffset = 0.0
                    }

                    // Convert glyph position to the coordinate system of the label
                    let glyphX = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil) + glyphPosition.x + alignmentOffset
                    let glyphY = rect.height - currentLineYOffset - glyphAscent
                    
                    if characterInWordIndex == 0 {
                        mutableWordPathX = glyphX
                        if granularity == .word {
//                            prevX = glyphX
                        }
                    }
                    
                    if let glyph = CTRunGetGlyphsPtr(run)?[glyphIndex] {
                        var runFont: CTFont?
                        if let attributes = CTRunGetAttributes(run) as? [NSAttributedString.Key: Any] {
                            if let font = attributes[.font] {
                                runFont = (font as! CTFont)
                            }
                            context.apply(attributes: attributes)
                        }
                        if let s = stringFromGlyph(glyph, font: runFont!) {
                            str.append(s)
                        }
                        if let runFont, let cgPath = CTFontCreatePathForGlyph(runFont, glyph, nil) {
                            switch granularity {
                            case .character:
                                context.setFillColor(UIColor.white.cgColor)
                                let characterWidth = CTFontGetAdvancesForGlyphs(runFont, .horizontal, [glyph], nil, 1)
                                var boundingBox = CGRect.zero
                                CTFontGetBoundingRectsForGlyphs(font, .default, [glyph], &boundingBox, 1)
                                let characterHeight = boundingBox.height
                                context.translateBy(x: glyphX - prevX, y: 0)
                                prevX = glyphX
                                context.saveGState()
                                let translation = textAnimation.translation(playbackTime: currentTime, characterIndex: fullCharacterIndex, wordIndex: wordIndex, characterIndexInWord: characterInWordIndex)
                                let characterTransform = textAnimation.characterTransform(playbackTime: currentTime, characterIndex: fullCharacterIndex, wordIndex: wordIndex, characterIndexInWord: characterInWordIndex, characterWidth: characterWidth, characterHeight: characterHeight)
                                context.translateBy(x: translation.x, y: translation.y)
                                context.concatenate(characterTransform)
                                let opacity = textAnimation.opacity(playbackTime: currentTime, characterIndex: fullCharacterIndex, wordIndex: wordIndex, characterIndexInWord: characterInWordIndex)
                                context.setAlpha(opacity)
                                context.addPath(cgPath)
                                context.fillPath()
                                context.restoreGState()
                                isPreviousCharacterSpaceOrNewLine = false
                            case .word:
//                                context.setFillColor(UIColor.white.cgColor)
//                                context.translateBy(x: glyphX - prevX, y: 0)
//                                prevX = glyphX
//                                context.saveGState()
//                                let translation = waveAnimation.translation(playbackTime: currentTime, characterIndex: fullCharacterIndex, wordIndex: wordIndex, characterIndexInWord: characterInWordIndex)
//                                context.translateBy(x: translation.x, y: translation.y)
//                                context.addPath(cgPath)
//                                context.fillPath()
//                                context.restoreGState()
//                                characterInWordIndex += 1
//                                isPreviousCharacterSpaceOrNewLine = false
//                                if characterInWordIndex == 0 {
//                                    mutableWordPath.move(to: CGPoint(x: glyphX, y: 0))
//                                }
//                                mutableWordPath.move(to: CGPoint(x: 30*glyphIndex, y: 0))
                                let characterWidth = CTFontGetAdvancesForGlyphs(runFont, .horizontal, [glyph], nil, 1)
                                let trans = CGAffineTransform(translationX: characterInWordIndex == 0 ? 0 : prevX, y: 0)
                                prevX += characterWidth
                                mutableWordPath.addPath(cgPath, transform: trans)
                                isPreviousCharacterSpaceOrNewLine = false
                            case .full:
                                context.setFillColor(UIColor.white.cgColor)
                                context.translateBy(x: glyphX - prevX, y: 0)
                                prevX = glyphX
                                context.saveGState()
                                let translation = textAnimation.translation(playbackTime: currentTime, characterIndex: fullCharacterIndex, wordIndex: wordIndex, characterIndexInWord: characterInWordIndex)
                                context.translateBy(x: translation.x, y: translation.y)
                                context.addPath(cgPath)
                                context.fillPath()
                                context.restoreGState()
                                characterInWordIndex += 1
                                isPreviousCharacterSpaceOrNewLine = false
                            }
                            characterInWordIndex += 1
                        } else {
                            // this is a space
                            if !isPreviousCharacterSpaceOrNewLine {
                                switch granularity {
                                case .character:
                                    break
                                case .word:
                                    context.saveGState()
                                    context.translateBy(x: mutableWordPathX, y: 0)
                                    let translation = textAnimation.translation(playbackTime: currentTime, characterIndex: fullCharacterIndex, wordIndex: wordIndex, characterIndexInWord: characterInWordIndex)
//                                    context.translateBy(x: translation.x, y: translation.y)
                                    
                                    let wordTransform = textAnimation.wordTransform(playbackTime: currentTime, wordIndex: wordIndex, characterWidth: mutableWordPath.boundingBox.width, characterHeight: mutableWordPath.boundingBox.height)
                                    context.concatenate(wordTransform)
                                    
                                    context.setFillColor(UIColor.white.cgColor)
//                                    print("((( going to draw path: \(mutableWordPath)")
                                    context.addPath(mutableWordPath.copy()!)
                                    context.fillPath()
                                    context.restoreGState()
                                    timesDrawn += 1
                                    mutableWordPath = CGMutablePath()
                                    prevX = 0
                                case .full:
                                    break
                                }
                                wordIndex += 1
                                characterInWordIndex = 0
                                isPreviousCharacterSpaceOrNewLine = true
                                str = ""
                            } else {
                                print("double space")
                            }// if !isPreviousCharacterSpaceOrNewLine {
                        }// if let runFont, let cgPath = CTFontCreatePathForGlyph(runFont, glyph, nil) {
                        
                        if glyphIndex == glyphCount - 1 {
                            context.translateBy(x: mutableWordPathX, y: 0)
                            context.saveGState()
                            let translation = textAnimation.translation(playbackTime: currentTime, characterIndex: fullCharacterIndex, wordIndex: wordIndex, characterIndexInWord: characterInWordIndex)
//                                    context.translateBy(x: translation.x, y: translation.y)
                            
                            let wordTransform = textAnimation.wordTransform(playbackTime: currentTime, wordIndex: wordIndex, characterWidth: mutableWordPath.boundingBox.width, characterHeight: mutableWordPath.boundingBox.height)
                            context.concatenate(wordTransform)
                            
                            context.setFillColor(UIColor.white.cgColor)
//                            print("((( going to draw path: \(mutableWordPath)")
                            context.addPath(mutableWordPath.copy()!)
                            context.fillPath()
                            context.restoreGState()
                            timesDrawn += 1
                            mutableWordPath = CGMutablePath()
                            prevX = 0
                            wordIndex += 1
                        }
                        
//                        context.move(to: CGPoint(x: glyphX, y: glyphY))
                        fullCharacterIndex += 1
                    } else {
                        print("no glyph $%^UI")
                    }// if glyph
                } // for glyphIndex in 0..<glyphCount {
//                print("times drawn: \(timesDrawn)")
            } // for run in glyphRuns {
            wordIndex = 0
            context.restoreGState()
            prevX = 0.0
            currentLineYOffset += ctLineHeight(ctLine: line)
        } // for (lineIndex, line) in lines.enumerated() {
        
        context.restoreGState()
    }
    
    
    func ctFrameHeight(ctFrame: CTFrame) -> CGFloat {
        let lines = CTFrameGetLines(ctFrame) as! [CTLine]
        
        var totalHeight: CGFloat = 0

        for line in lines {
            totalHeight += ctLineHeight(ctLine: line)
        }

        return totalHeight
    }
    
    func ctLineHeight(ctLine: CTLine) -> CGFloat {
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        CTLineGetTypographicBounds(ctLine, &ascent, &descent, &leading)

        return ascent + descent + leading
    }
    
    func isSpaceOrNewline(for glyph: CGGlyph, in font: CTFont) -> Bool {
        let characters = UnsafeMutablePointer<UniChar>.allocate(capacity: 1)
        var glyphs = [glyph]
        
        CTFontGetGlyphsForCharacters(font, characters, &glyphs, 1)
        
        let unicodeScalar = UnicodeScalar(characters.pointee)
        characters.deallocate()
        
        return unicodeScalar == " " || unicodeScalar == "\n"
    }
    
    func lineCGPath(ctLine: CTLine) -> CGMutablePath {
        // Get the array of glyph runs in the line
        let glyphRuns = CTLineGetGlyphRuns(ctLine) as! [CTRun]

        // Create a mutable path to store the combined paths of all glyph runs
        let combinedPath = CGMutablePath()

        // Iterate over each glyph run and add its path to the combined path
        for run in glyphRuns {
            let glyphCount = CTRunGetGlyphCount(run)
            var glyphs = [CGGlyph](repeating: 0, count: glyphCount)
            var positions = [CGPoint](repeating: .zero, count: glyphCount)
            
            // Get the glyph indices and positions
            CTRunGetGlyphs(run, CFRangeMake(0, 0), &glyphs)
            CTRunGetPositions(run, CFRangeMake(0, 0), &positions)
            
            // Get the font for the current run
            let attributes = CTRunGetAttributes(run) as? [NSAttributedString.Key: Any]
            let runFont = attributes?[.font] as! CTFont
            
            // Create paths for each glyph and add them to the combined path with proper spacing
            for i in 0..<glyphCount {
                let glyph = glyphs[i]
                let position = positions[i]
                
                if let glyphPath = CTFontCreatePathForGlyph(runFont, glyph, nil) {
                    var transform = CGAffineTransform(translationX: position.x, y: position.y)
                    combinedPath.addPath(glyphPath, transform: transform)
                }
            }
        }
        return combinedPath
    }
    
    
    func stringFromGlyph(_ glyph: CGGlyph, font: CTFont) -> String? {
        // Create a Glyph array containing the single glyph
        let glyphs = [glyph]

        // Retrieve the corresponding character indices
        var characters = [UniChar](repeating: 0, count: glyphs.count)
        CTFontGetGlyphsForCharacters(font, glyphs, &characters, glyphs.count)

        // Convert the character indices to a string
        let string = String(utf16CodeUnits: characters, count: characters.count)
        return string
    }
    
}



private func makeCGColor(_ value: Any) -> CGColor {
    if let color = value as? UIColor {
        return color.cgColor
    } else {
        return value as! CGColor
    }
}

private extension CGContext {
    func apply(attributes: [NSAttributedString.Key : Any]) {
        for (key, value) in attributes {
            switch key {
            case .font:
                let ctFont = value as! CTFont
                let cgFont = CTFontCopyGraphicsFont(ctFont, nil)
                self.setFont(cgFont)
                self.setFontSize(CTFontGetSize(ctFont))

            case .foregroundColor:
                self.setFillColor(makeCGColor(value))

            case .strokeColor:
                self.setStrokeColor(makeCGColor(value))

            case .strokeWidth:
                let width = value as! CGFloat

                let mode: CGTextDrawingMode
                if width < 0 {
                    mode = .fillStroke
                } else if width == 0 {
                    mode = .fill
                } else {
                    mode = .stroke
                }
                self.setTextDrawingMode(mode)
                self.setLineWidth(width)

            // Remember: NSShadow does not honor CTM. It is always in the default user coordinates.
            case .shadow:
                let shadow = value as! NSShadow
                if let color = shadow.shadowColor {
                    self.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: makeCGColor(color))
                } else {
                    self.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius)
                }

            //
            // Ignore for various reasons
            //

            // Ignore because CTRun already handles it
            case .kern,
                 .ligature,
                 .writingDirection:
                break

            // Ingore because other methods already handle it
            case .baselineOffset:
                break

            // Ignore because they are unsupported by CoreText
            case .expansion,    // Expansion is not fully supported; it'll act more like tracking
            .link,
            .obliqueness,
            .textEffect:
                break

            // Ignore because it would look bad if implemented
            case .backgroundColor,
                 .paragraphStyle,
                 .strikethroughStyle,
                 .strikethroughColor,
                 .underlineStyle,
                 .underlineColor:
                break

            // Ignore because it's unneeded information
            case .init("NSOriginalFont"):   // Original font before substitution.
                break

            default:
                print("Unknown attribute: \(key) = \(value)")   // FIXME: Just for debugging.
            }
        }
    }
}

//extension CGContext {
//    func loop(text: String?, font: CTFont, closure: (_ cgPath: CGPath) -> Void) {
//        context.saveGState()
//        var totalTranslatedX = outlineWidth/2 // 0.0
//        context.translateBy(x: totalTranslatedX, y: -outlineWidth/2)
//        
//        let existingSlantAngle: CGFloat = CTFontGetSlantAngle(font)
//        if existingSlantAngle == 0.0 && slantAngle != 0.0 {
//            let slantTransform = CGAffineTransform(a: 1, b: 0, c: slantAngle, d: 1, tx: 0, ty: 0)
//            context.concatenate(slantTransform)
//        }
//        for (_, character) in (text ?? "").enumerated() {
//            if let glyph = glyphs(character: character) {
//                let advance = advanceSize(glyph: glyph)
//                if let cgPath = CTFontCreatePathForGlyph(font, glyph, nil) {
//                    closure(cgPath)
//                }
//                totalTranslatedX += advance.width
//                context.translateBy(x: advance.width, y: 0)
//            }
//        }
//        context.translateBy(x: -totalTranslatedX, y: outlineWidth/2)
//        //        context.restoreGState()
//    }
//}


extension CGPath {
    
    static func union(path1: CGPath, path2: CGPath) -> CGPath {
        // Convert CGPaths to UIBezierPaths
        let bezierPath1 = UIBezierPath(cgPath: path1)
        let bezierPath2 = UIBezierPath(cgPath: path2)

        // Perform union operation
        bezierPath1.append(bezierPath2)

        // Return the result as CGPath
        return bezierPath1.cgPath
    }
    
    func outline(radius: CGFloat) -> CGPath {
        let outlinedPath = self.copy(strokingWithWidth: radius, lineCap: .butt, lineJoin: .round, miterLimit: 10).mutableCopy() ?? CGMutablePath()
        let largerSquare = CGRect(x: boundingBox.origin.x - radius,
                                  y: boundingBox.origin.y - radius,
                                  width: boundingBox.size.width + radius*2.0,
                                  height: boundingBox.size.height + radius*2.0)
        
        let squarePath = CGPath(rect: largerSquare, transform: nil)
        
        let intersect = outlinedPath.intersection(squarePath)
        return intersect
    }
    
}
