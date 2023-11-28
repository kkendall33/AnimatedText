
import UIKit

class AnimatedLabel: UILabel {
    
    var neonOutlineRadius: Double? {
        didSet {
            setNeedsDisplay()
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
    
    func drawEach(rect: CGRect) {
        guard let attributedText = attributedText,
            let context = UIGraphicsGetCurrentContext() else { return }
        
        let mut = NSMutableAttributedString(attributedString: attributedText)
        let p = NSMutableParagraphStyle()
        p.alignment = self.textAlignment
        mut.addAttribute(.paragraphStyle, value: p, range: NSMakeRange(0, attributedText.length))

        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setLineJoin(.round)

        let framesetter = CTFramesetterCreateWithAttributedString(mut.copy() as! NSAttributedString)
        let path = CGPath(rect: bounds, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedText.length), path, nil)

        guard let lines = CTFrameGetLines(frame) as? [CTLine] else { return }
        
        let ctFrameHeight = ctFrameHeight(ctFrame: frame)
        let ctFrameYOffset: CGFloat = (rect.height / 2) - (ctFrameHeight / 2)
        var currentLineYOffset: CGFloat = ctFrameYOffset

        for line in lines {
            let glyphRuns = CTLineGetGlyphRuns(line) as! [CTRun]
            let linebounds = CTLineGetBoundsWithOptions(line, [])
            let lineWidth = linebounds.width
            
            let mutableStrokePath = lineCGPath(ctLine: line)
//
//            let boundingBox = CTLineGetBoundsWithOptions(line, .useGlyphPathBounds)
//            let offset = 10.0
//            let largerSquare = CGRect(x: boundingBox.origin.x - offset,
//                                      y: boundingBox.origin.y - offset,
//                                      width: boundingBox.size.width + offset*2.0,
//                                      height: boundingBox.size.height + offset*2.0)
//            
//            let squarePath = CGPath(rect: largerSquare, transform: nil)
            
//            if let neonOutlineRadius {
//                var outlineRadii: [Double] = []
////                let colors: [UIColor] = [.yellow, .systemPink, .systemPink, .systemPink, .systemPink, .systemPink, .systemPink, .systemPink, .systemPink]
//                var cur = neonOutlineRadius
//                while cur > 0 {
//                    outlineRadii.append(cur)
//                    cur -= 13
//                }
                
//                for (i, rad) in outlineRadii.enumerated() {
//                    context.saveGState()
//                    context.addPath(mutableStrokePath.outline(radius: rad))
//                    let color = i == 0 ? UIColor.yellow.cgColor : UIColor.systemPink.cgColor
//                    context.setShadow(offset: .zero, blur: 6.0, color: color)
//                    context.setLineWidth(1)
////                    context.setBlendMode(.colorDodge)
//                    context.setStrokeColor(color)
//                    context.strokePath()
//                    context.restoreGState()
//                }
//                self.outerPath = mutableStrokePath.outline(radius: neonOutlineRadius)
//                for (i, rad) in outlineRadii.enumerated() {
//                    context.saveGState()
//                    context.addPath(mutableStrokePath.outline(radius: rad))
//                    let color = i == 0 ? UIColor.yellow.cgColor : UIColor.systemPink.cgColor
//                    context.setShadow(offset: CGSize(width: 0, height: 0), blur: 4.0, color: color)
//                    
//                    context.setLineWidth(1.7)
//                    context.setLineDash(phase: rad*rad, lengths: [40,40])
//                    
//                    context.setStrokeColor(color)
//                    context.strokePath()
//                    context.restoreGState()
//                }
//                for (i, rad) in outlineRadii.enumerated() {
//                    context.saveGState()
//                    context.addPath(mutableStrokePath.outline(radius: rad))
//                    let color = i == 0 ? UIColor.yellow.cgColor : UIColor.systemPink.cgColor
//                    context.setShadow(offset: .zero, blur: 4.0, color: color)
//                    context.setLineWidth(1)
//                    context.setBlendMode(.multiply)
////                    context.setLineDash(phase: rad*rad, lengths: [20,40])
//                    
//                    context.setStrokeColor(color)
//                    context.strokePath()
//                    context.restoreGState()
//                }
//                for (i, rad) in outlineRadii.enumerated() {
//                    context.saveGState()
//                    context.addPath(mutableStrokePath.outline(radius: rad))
//                    let color = i == 0 ? UIColor.yellow.cgColor : UIColor.systemPink.cgColor
////                    context.setShadow(offset: .zero, blur: 4.0, color: color)
//                    context.setLineWidth(1)
////                    context.setBlendMode(.multiply)
////                    context.setLineDash(phase: rad*rad, lengths: [20,40])
//                    
//                    context.setStrokeColor(color)
//                    context.strokePath()
//                    context.restoreGState()
//                }
//            }
            
            context.saveGState()
            
            context.addPath(mutableStrokePath)
            context.setFillColor(UIColor.white.cgColor)
            context.setShadow(offset: .zero, blur: 20, color: UIColor.white.cgColor)
            context.fillPath()
            
            context.restoreGState()
            
            var entireCGPath = CGMutablePath()
            for run in glyphRuns {
                let glyphCount = CTRunGetGlyphCount(run)
                context.saveGState()
                
                context.apply(attributes: CTRunGetAttributes(run) as! [NSAttributedString.Key : Any])
                let paragraphStyle = CTRunGetAttributes(run) as? [NSAttributedString.Key: Any]
                let alignment = (paragraphStyle?[.paragraphStyle] as? NSParagraphStyle)?.alignment ?? .left
                
                defer {
                    context.restoreGState()
                }

                for i in 0..<glyphCount {
                    let glyphRange = CFRangeMake(i, 1)
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
                    
                    if let glyph = CTRunGetGlyphsPtr(run)?[i] {
                        
//                        context.textPosition = CGPoint(x: glyphX, y: glyphY)
                        
                        var runFont: CTFont?
                        if let attributes = CTRunGetAttributes(run) as? [NSAttributedString.Key: Any] {
                            if let font = attributes[.font] {
                                runFont = (font as! CTFont)
                            }
                        }
                        if let runFont, let cgPath = CTFontCreatePathForGlyph(runFont, glyph, nil) {
//                            print("cgPath: \(cgPath)")
//                            let strokedPath = CGPathCreateCopyByStrokingPath(originalPath, nil, strokeWidth, .butt, .miter, 10.0)
//                            var transform = CGAffineTransform.identity
//                            let strokedPath = cgPath.copy(strokingWithWidth: 4.0, lineCap: .butt, lineJoin: .round, miterLimit: 10)
                            
//                            closure(cgPath)
//                            context.move(to: CGPoint(x: glyphX, y: glyphY))
//                            context.translateBy(x: glyphX, y: glyphY)
//                            context.saveGState()
//                            context.move(to: CGPoint(x: glyphX, y: glyphY))
//                            context.addPath(cgPath)
//                            context.drawPath(using: .fill)
//                            context.restoreGState()
                        }
                        
                        
//                        context.move(to: CGPoint(x: glyphX, y: glyphY))
                    }
                }
            }
            currentLineYOffset += ctLineHeight(ctLine: line)
        }
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
