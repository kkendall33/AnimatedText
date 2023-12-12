import UIKit

class KLabel: UIView {
    
    var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var outlineWidth: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var font: UIFont = UIFont(name: "SFProDisplay-Bold", size: 64) ?? UIFont.systemFont(ofSize: 22) {
        didSet {
//            slantAngle = CTFontGetSlantAngle(font)
            setNeedsDisplay()
        }
    }
    
    var textColor: UIColor = .red.withAlphaComponent(0.5) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var outlineColor: UIColor = .yellow {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var slantAngle: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var m34Divisor: CGFloat = 0.0 {
        didSet {
            updateTransform()
        }
    }
    
    var transformDegrees: Double = 0.0 {
        didSet {
            updateTransform()
        }
    }
    
    func updateTransform() {
        if m34Divisor != 0 {
            var perspectiveTransform = CATransform3DIdentity
            perspectiveTransform.m34 = -1.0 / m34Divisor
            let rotationTransform = CATransform3DRotate(perspectiveTransform, transformDegrees.degreesToRadians, 0, 1, 0)
            layer.transform = rotationTransform
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        clipsToBounds = false
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(CGRect(x: rect.minX - outlineWidth, y: -outlineWidth, width: rect.width + outlineWidth*2, height: rect.height + outlineWidth*2))
        print("draw rect")
        
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
//        super.draw(layer, in: ctx)
        print("draw layer ctx")
        ctx.scaleBy(x: 1.0, y: -1.0)
        let fontLineHeight = font.ascender - abs(font.descender)
        
        ctx.translateBy(x: 0, y: -fontLineHeight)
        
        ctx.setLineJoin(.round)
        
        ctx.setFillColor(textColor.cgColor)
        ctx.setLineWidth(outlineWidth)
        ctx.setStrokeColor(outlineColor.cgColor)
        
//        strokePath(text: text, context: ctx) { cgPath in
//            print("")
//        }
        
//        loop(text: text, context: ctx) { cgPath in
//            ctx.setBlendMode(.clear)
//            ctx.addPath(cgPath)
//            ctx.strokePath()
//        }
        
        loop(text: text, context: ctx) { cgPath in
//            ctx.setBlendMode(.clear)
            ctx.addPath(cgPath)
            ctx.strokePath()
        }
        
        loop(text: text, context: ctx) { cgPath in
//            ctx.setBlendMode(.clear)
            ctx.addPath(cgPath)
//            ctx.strokePath()
            ctx.replacePathWithStrokedPath()
            ctx.fillPath()
            ctx.clip()
        }
        
        
//        loop(text: text, context: ctx) { cgPath in
//            ctx.addPath(cgPath)
////            ctx.setBlendMode(.destinationAtop)
//            ctx.strokePath()
////            ctx.fillPath(using: .evenOdd)
//        }
//        ctx.clip(to: [CGRect(x: 0, y: 0, width: 20, height: 20)])
        
//        loop(text: text, context: ctx) { cgPath in
//            ctx.addPath(cgPath)
//        }
//        ctx.clip()
        

        
//        let maskLayer = CAShapeLayer()
//        maskLayer.backgroundColor = UIColor.black.cgColor
////        maskLayer.path = CGPath(rect: CGRect(x: 0, y: 0, width: 40, height: fontLineHeight), transform: nil)
//        if let p = fillPath(text: text, context: ctx) {
//            maskLayer.path = p
//        }
//        maskLayer.fillRule = .evenOdd
//        layer.mask = maskLayer
    }
    
    func glyphs(character: Character) -> CGGlyph? {
        var unichar = [UniChar](String(character).utf16)
        var glyph = [CGGlyph](repeating: 0, count: unichar.count)
        if CTFontGetGlyphsForCharacters(font, &unichar, &glyph, unichar.count) {
            return glyph[0]
        } else {
            return nil
        }
    }
    
    func advanceSize(glyph: CGGlyph) -> CGSize {
        var glyph = glyph
        var advance = CGSize.zero
        CTFontGetAdvancesForGlyphs(font, .horizontal, &glyph, &advance, 1)
        return advance
    }
    
    func loop(text: String?, context: CGContext, closure: (_ cgPath: CGPath) -> Void) {
        context.saveGState()
        var totalTranslatedX = outlineWidth/2 // 0.0
        context.translateBy(x: totalTranslatedX, y: -outlineWidth/2)
        
        let existingSlantAngle: CGFloat = CTFontGetSlantAngle(font)
        if existingSlantAngle == 0.0 && slantAngle != 0.0 {
            let slantTransform = CGAffineTransform(a: 1, b: 0, c: slantAngle, d: 1, tx: 0, ty: 0)
            context.concatenate(slantTransform)
        }
        for (_, character) in (text ?? "").enumerated() {
            if let glyph = glyphs(character: character) {
                let advance = advanceSize(glyph: glyph)
                if let cgPath = CTFontCreatePathForGlyph(font, glyph, nil) {
                    closure(cgPath)
                }
                totalTranslatedX += advance.width
                context.translateBy(x: advance.width, y: 0)
            }
        }
        context.translateBy(x: -totalTranslatedX, y: outlineWidth/2)
//        context.restoreGState()
    }
    
    func strokePath(text: String?, context: CGContext, closure: (_ cgPath: CGPath) -> Void) {
        context.saveGState()
        var totalTranslatedX = outlineWidth/2 // 0.0
        context.translateBy(x: totalTranslatedX, y: -outlineWidth/2)
        
        let existingSlantAngle: CGFloat = CTFontGetSlantAngle(font)
        if existingSlantAngle == 0.0 && slantAngle != 0.0 {
            let slantTransform = CGAffineTransform(a: 1, b: 0, c: slantAngle, d: 1, tx: 0, ty: 0)
            context.concatenate(slantTransform)
        }
        for (_, character) in (text ?? "").enumerated() {
            if let glyph = glyphs(character: character) {
                let advance = advanceSize(glyph: glyph)
                if let cgPath = CTFontCreatePathForGlyph(font, glyph, nil) {
                    context.addPath(cgPath)
                }
                totalTranslatedX += advance.width
                context.translateBy(x: advance.width, y: 0)
            }
        }
//        context.strokePath()
        if let daPath = context.path {
            print("path before replace: \(daPath)")
        }
        context.replacePathWithStrokedPath()
        if let daPath = context.path {
            print("strokePath: \(daPath)")
        }
        context.restoreGState()
    }
    
    func fillPath(text: String?, context: CGContext) -> CGPath? {
        let cgMutablePath = CGMutablePath()
//        let fontLineHeight = font.ascender - abs(font.descender)
        var totalTranslatedX = 0.0
        for (_, character) in (text ?? "").enumerated() {
            if let glyph = glyphs(character: character) {
                let advance = advanceSize(glyph: glyph)
                if let cgPath = CTFontCreatePathForGlyph(font, glyph, nil) {
                    cgMutablePath.addPath(cgPath)
                }
                totalTranslatedX += advance.width

                // Apply the transform to the path
//                cgMutablePath.addPath(cgMutablePath, transform: translationTransform)
                cgMutablePath.move(to: CGPoint(x: 200, y: 0))
            }
        }
        return cgMutablePath.copy()
    }
    
    override func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter) {
        super.draw(rect, for: formatter)
        print("draw rect formatter")
    }
    
    override func drawHierarchy(in rect: CGRect, afterScreenUpdates afterUpdates: Bool) -> Bool {
        let val = super.drawHierarchy(in: rect, afterScreenUpdates: afterUpdates)
        print("draw hierarchy")
        return val
    }
    
    override func layerWillDraw(_ layer: CALayer) {
        super.layerWillDraw(layer)
        print("layer will draw")
    }
    
}


extension Double {
    var degreesToRadians: Double {
        return self * .pi / 180.0
    }
}
