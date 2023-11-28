
import CoreImage

public protocol FilterType: AnyObject {
    var name: String { get }
    static var standard: Self { get }
    func configureValues(ciFilter: CIFilter)
    func ciFilter() -> CIFilter?
}

internal protocol ChangeObserving: AnyObject {
    var onValueChange: () -> Void { get set }
}

extension CIFilter {
    public convenience init?(filterType: FilterType) {
        self.init(name: filterType.name)
        filterType.configureValues(ciFilter: self)
    }
}
