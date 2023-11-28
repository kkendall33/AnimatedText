import UIKit
import CoreText

class PathTextView: UITextView {

    var textPath: UIBezierPath?

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let textPath = textPath else { return }

        // Create an attributed string with the text you want to draw
        let text = "Hello, World!"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: textColor as Any
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)

        // Create a framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)

        // Create a frame
        let framePath = textPath.cgPath
        let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), framePath, nil)

        // Flip the coordinate system
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // Draw the text along the path
        CTFrameDraw(frameRef, context)
    }
}
