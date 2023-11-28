
import UIKit

var floatNumberFormatter: NumberFormatter = {
    let nf = NumberFormatter()
    nf.numberStyle = .decimal
    return nf
}()


class StepperAndLabelView: UIView {
    
    var didChangeValue: (_ newValue: Double) -> Void = { _ in }
    
    var valueLabelFloat: CGFloat = 0.0 {
        didSet {
            valueLabel.text = floatNumberFormatter.string(from: NSNumber(value: valueLabelFloat))
        }
    }
    
    // UI components
    let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    let displayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Type"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        return label
    }()
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // UI setup
    private func setupUI() {
        // Add UI components to the view
        addSubview(stepper)
        addSubview(displayLabel)
        addSubview(valueLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            stepper.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepper.topAnchor.constraint(equalTo: topAnchor),
            stepper.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            displayLabel.leadingAnchor.constraint(equalTo: stepper.trailingAnchor, constant: 16),
            displayLabel.topAnchor.constraint(equalTo: topAnchor),
            displayLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: displayLabel.trailingAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    // Stepper value changed action
    @objc private func stepperValueChanged() {
        valueLabel.text = "\(stepper.value)"
        didChangeValue(stepper.value)
    }

}
