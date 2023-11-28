
import CoreImage

extension CIFilter {
    
    public static let zoomBlurName = "CIZoomBlur"
    
    public class ZoomBlur: FilterType, ChangeObserving {
        public var onValueChange: () -> Void = {}
        public let name = zoomBlurName
        
        public static var standard: Self {
            return ZoomBlur() as! Self
        }
        
        public func configureValues(ciFilter: CIFilter) {
            if let inputCenter {
                ciFilter.setValue(inputCenter, forKey: kCIInputCenterKey)
            }
            if let inputAmount {
                ciFilter.setValue(inputAmount, forKey: kCIInputAmountKey)
            }
        }
        
        public func ciFilter() -> CIFilter? {
            return CIFilter(filterType: self)
        }
        
        var inputCenter: CIVector? = nil {
            didSet {
                onValueChange()
            }
        }
        var inputAmount: Double? = nil {
            didSet {
                onValueChange()
            }
        }
    }
    
}

extension CIFilter {
    
    public static let boxBlurName = "CIBoxBlur"
    
    public class BoxBlur: FilterType, ChangeObserving {
        public let name = boxBlurName
        public var onValueChange: () -> Void = {}
        public static var standard: Self {
            return BoxBlur() as! Self
        }
        
        public func configureValues(ciFilter: CIFilter) {
            if let inputRadius {
                ciFilter.setValue(inputRadius, forKey: kCIInputRadiusKey)
            }
        }
        
        public func ciFilter() -> CIFilter? {
           return CIFilter(filterType: self)
        }
        
        var inputRadius: Double? = nil {
            didSet {
                onValueChange()
            }
        }
    }
    
}

extension CIFilter {
    
    public static let motionBlurName = "CIMotionBlur"
    
    public class MotionBlur: FilterType, ChangeObserving {
        public let name = motionBlurName
        public var onValueChange: () -> Void = {}
        public static var standard: Self {
            return MotionBlur() as! Self
        }
        
        public func configureValues(ciFilter: CIFilter) {
            if let inputRadius {
                ciFilter.setValue(inputRadius, forKey: kCIInputRadiusKey)
            }
            if let inputAngle {
                ciFilter.setValue(inputAngle, forKey: kCIAttributeTypeAngle)
            }
        }
        
        public func ciFilter() -> CIFilter? {
           return CIFilter(filterType: self)
        }
        
        var inputRadius: Double? = nil {
            didSet {
                onValueChange()
            }
        }
        
        var inputAngle: Double? = nil {
            didSet {
                onValueChange()
            }
        }
    }
    
}



extension CIFilter {
    
    public static let bumpDistortionName = "CIBumpDistortion"
    
    public class BumpDistortion: FilterType, ChangeObserving {
        public let name = bumpDistortionName
        public var onValueChange: () -> Void = {}
        public static var standard: Self {
            return BumpDistortion() as! Self
        }
        
        public func configureValues(ciFilter: CIFilter) {
            if let inputCenter {
                ciFilter.setValue(inputCenter, forKey: kCIInputCenterKey)
            }
            if let inputRadius {
                ciFilter.setValue(inputRadius, forKey: kCIInputRadiusKey)
            }
            if let inputScale {
                ciFilter.setValue(inputScale, forKey: kCIInputScaleKey)
            }
        }
        
        public func ciFilter() -> CIFilter? {
           return CIFilter(filterType: self)
        }
        
        var inputCenter: CIVector? = nil {
            didSet {
                onValueChange()
            }
        }
        
        var inputRadius: Double? = nil {
            didSet {
                onValueChange()
            }
        }
        
        var inputScale: Double? = nil {
            didSet {
                onValueChange()
            }
        }
    }
    
}
