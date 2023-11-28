
import UIKit
import CoreImage

class FilterLabel: UILabel {
    
    var blurTypes: [FilterType] = [] {
        didSet {
            setNeedsDisplay()
            setupObjectObservers()
        }
    }
    
    public var radiusValue: Double = 5.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func setupObjectObservers() {
        for type in blurTypes {
            guard let observable = type as? ChangeObserving else { continue }
            observable.onValueChange = { [weak self] in
                self?.notifyObjectsChanged()
            }
        }
    }

    private func notifyObjectsChanged() {
        setNeedsDisplay()
    }
    
    override func drawText(in rect: CGRect) {
        if blurTypes.isEmpty {
            super.drawText(in: rect)
            return
        }
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Save the current context state
        context.saveGState()
        defer {
            context.restoreGState()
        }

        UIGraphicsBeginImageContext(bounds.size)
        
        // Draw the text using the parent class's drawText method
        super.drawText(in: rect)

        // Get the image of the text
        guard let textImage = UIGraphicsGetImageFromCurrentImageContext(),
              let cgImage = textImage.cgImage else {
            UIGraphicsEndImageContext()
            return
        }
        UIGraphicsEndImageContext()
        
        var ciImage = CIImage(cgImage: cgImage)
        for type in blurTypes {
            guard let filter = CIFilter(filterType: type) else {
                assert(false, "Got no filter here: \(type)")
                continue
            }
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage {
                ciImage = outputImage
            }
        }
        
        let filteredImage = UIImage(ciImage: ciImage)
        filteredImage.draw(in: rect)
    }
    
}

extension CGPoint {
    var ciVector: CIVector {
        return CIVector(x: x, y: y)
    }
}
