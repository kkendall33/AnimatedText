import UIKit

class LabelAttributesViewController: UIViewController, UITextFieldDelegate {
    
    private var displayText: String = "Display Text" {
        didSet {
            kLabel.text = displayText
        }
    }

    private lazy var kLabel: KLabel = {
        let label = KLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = displayText
        label.textColor = textColor
        label.outlineColor = outlineColor
        return label
    }()
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.text = displayText
        text.delegate = self
        text.translatesAutoresizingMaskIntoConstraints = false
        text.borderStyle = .roundedRect
        return text
    }()
    private var slantStepper: UIStepper = UIStepper()
    private var slantLabel: UILabel = UILabel()
    private var m34Stepper: UIStepper = UIStepper()
    private var m34Label: UILabel = UILabel()
    private var m34DegreesStepper: UIStepper = UIStepper()
    private var m34DegreesLabel: UILabel = UILabel()
    private var outlineColorButton: UIButton = UIButton()
    private var textColorButton: UIButton = UIButton()
    private var fontButton: UIButton = UIButton()
    private let textColorPicker = UIColorPickerViewController()
    private let outlineColorPicker = UIColorPickerViewController()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var outlineStepper: StepperAndLabelView = {
        let stepper = StepperAndLabelView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.displayLabel.text = "Outline width:"
        stepper.didChangeValue = { newValue in
            self.kLabel.outlineWidth = newValue
        }
        return stepper
    }()
    
    private var outlineColor: UIColor = .yellow {
        didSet {
            kLabel.outlineColor = outlineColor
            outlineColorButton.setTitleColor(outlineColor, for: .normal)
        }
    }
    
    private var textColor: UIColor = .red {
        didSet {
            kLabel.textColor = textColor
            textColorButton.setTitleColor(textColor, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false

        
        view.addSubview(verticalStackView)
        
        verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        kLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        verticalStackView.addArrangedSubview(kLabel)
        
        verticalStackView.addArrangedSubview(textField)
        verticalStackView.addArrangedSubview(outlineStepper)
        
        verticalStackView.addArrangedSubview(UIView())

//        view.addSubview(kLabel)

//        textField.placeholder = "Enter text"
//        textField.text = "Kyle"
//        textField.borderStyle = .roundedRect
//        textField.frame = CGRect(x: 50, y: kLabel.frame.maxY + 20, width: 200, height: 30)
//        textField.delegate = self  // Set the delegate to self
//        view.addSubview(textField)
//
//        // Stepper setup
//        stepper.frame = CGRect(x: 50, y: textField.frame.maxY + 20, width: 94, height: 29)
//        stepper.minimumValue = 0
//        stepper.maximumValue = 100
//        stepper.value = 0
//        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
//        view.addSubview(stepper)
//
//        // Number label setup
//        numberLabel.frame = CGRect(x: stepper.frame.maxX + 10, y: stepper.frame.minY, width: 200, height: 30)
//        numberLabel.text = "Outline value: \(Int(stepper.value))"
//        numberLabel.textAlignment = .center
//        view.addSubview(numberLabel)
//        
//        // Stepper setup
//        slantStepper.frame = CGRect(x: 50, y: stepper.frame.maxY + 20, width: 94, height: 29)
//        slantStepper.minimumValue = -360
//        slantStepper.maximumValue = 360
//        slantStepper.value = 0
//        slantStepper.addTarget(self, action: #selector(slantStepperValueChanged), for: .valueChanged)
//        view.addSubview(slantStepper)
//
//        // Number label setup
//        slantLabel.frame = CGRect(x: slantStepper.frame.maxX + 10, y: slantStepper.frame.minY, width: 200, height: 30)
//        slantLabel.text = "Slant value: \(Int(slantStepper.value))"
//        slantLabel.textAlignment = .center
//        view.addSubview(slantLabel)
//        
//        // M34 setup
//        m34Stepper.frame = CGRect(x: 50, y: slantStepper.frame.maxY + 20, width: 94, height: 29)
//        m34Stepper.minimumValue = -500_000
//        m34Stepper.maximumValue = 500_000
//        m34Stepper.value = 0
//        m34Stepper.stepValue = 50
//        m34Stepper.addTarget(self, action: #selector(m34StepperValueChanged), for: .valueChanged)
//        view.addSubview(m34Stepper)
//
//        // M34 label setup
//        m34Label.frame = CGRect(x: m34Stepper.frame.maxX + 10, y: m34Stepper.frame.minY, width: 200, height: 30)
//        m34Label.text = "M34 value: \(Int(slantStepper.value))"
//        m34Label.textAlignment = .center
//        view.addSubview(m34Label)
//        
//        // M34 Deg setup
//        m34DegreesStepper.frame = CGRect(x: 50, y: m34Stepper.frame.maxY + 20, width: 94, height: 29)
//        m34DegreesStepper.minimumValue = -360
//        m34DegreesStepper.maximumValue = 360
//        m34DegreesStepper.value = 0
//        m34DegreesStepper.stepValue = 5
//        m34DegreesStepper.wraps = true
//        m34DegreesStepper.addTarget(self, action: #selector(degreesM34StepperValueChanged), for: .valueChanged)
//        view.addSubview(m34DegreesStepper)
//
//        // M34 Deg label setup
//        m34DegreesLabel.frame = CGRect(x: m34DegreesStepper.frame.maxX + 10, y: m34DegreesStepper.frame.minY, width: 200, height: 30)
//        m34DegreesLabel.text = "M34 degrees value: \(Int(m34DegreesStepper.value))"
//        m34DegreesLabel.textAlignment = .center
//        view.addSubview(m34DegreesLabel)
//
//        // Outline color picker button
//        outlineColorButton.frame = CGRect(x: 50, y: m34DegreesLabel.frame.maxY + 20, width: 140, height: 30)
//        outlineColorButton.setTitle("Outline Color", for: .normal)
//        outlineColorButton.addTarget(self, action: #selector(presentOutlineColorPicker), for: .touchUpInside)
//        outlineColorButton.setTitleColor(outlineColor, for: .normal)
//        outlineColorButton.titleLabel?.layer.shadowColor = UIColor.black.cgColor
//        outlineColorButton.titleLabel?.layer.masksToBounds = false
//        outlineColorButton.titleLabel?.layer.shadowOffset = CGSize(width: 2, height: 2)
//        outlineColorButton.titleLabel?.layer.shadowRadius = 4
//        view.addSubview(outlineColorButton)
//
//        // Text color picker button
//        textColorButton.frame = CGRect(x: 50, y: outlineColorButton.frame.maxY + 20, width: 140, height: 30)
//        textColorButton.setTitle("Text Color", for: .normal)
//        textColorButton.addTarget(self, action: #selector(presentTextColorPicker), for: .touchUpInside)
//        textColorButton.setTitleColor(textColor, for: .normal)
//        textColorButton.titleLabel?.shadowColor = UIColor.black
//        textColorButton.titleLabel?.shadowOffset = CGSize(width: 2, height: 2)
//        view.addSubview(textColorButton)
//        
//        // Text color picker button
//        fontButton.frame = CGRect(x: 20, y: textColorButton.frame.maxY + 20, width: 140, height: 30)
//        fontButton.setTitle("Font picker", for: .normal)
//        fontButton.setTitleColor(.black, for: .normal)
//        fontButton.addTarget(self, action: #selector(didTapFonts), for: .touchUpInside)
//        view.addSubview(fontButton)
//        
//        textColorPicker.delegate = self
//        outlineColorPicker.delegate = self
//        
//        // Example usage:
//        filteredLabel.frame = CGRect(x: 50, y: 550, width: 200, height: 100)
//        filteredLabel.text = "Hello, Core Image!"
//        zoomBlur.inputCenter = CIVector(x: 37, y: 50)
//        filteredLabel.blurTypes = [boxBlur, zoomBlur]
//        view.addSubview(filteredLabel)
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let newText = textField.text {
            kLabel.text = newText
//            filteredLabel.text = newText
        }
    }

    // MARK: - UIStepper Action

    @objc func stepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
//        numberLabel.text = "Outline value: \(value)"
        kLabel.outlineWidth = CGFloat(value)
    }

    @objc func slantStepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        slantLabel.text = "Slant value: \(value)"
        kLabel.slantAngle = Double(value).degreesToRadians
    }
    
    @objc func m34StepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        m34Label.text = "m34 divisor value: \(value)"
        kLabel.m34Divisor = CGFloat(value)
    }
    
    @objc func degreesM34StepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        m34DegreesLabel.text = "m34 degrees value: \(value)"
        kLabel.transformDegrees = CGFloat(value)
    }
    
    // MARK: - Color Picker Actions

    @objc func presentOutlineColorPicker() {
        presentColorPicker(for: .outline)
    }

    @objc func presentTextColorPicker() {
        presentColorPicker(for: .text)
    }

    func presentColorPicker(for type: ColorType) {
        switch type {
        case .outline:
            present(outlineColorPicker, animated: true, completion: nil)
        case .text:
            present(textColorPicker, animated: true, completion: nil)
        }
    }
    
    @objc private func didTapFonts() {
        let fontPicker = FontSelectorViewController(nibName: nil, bundle: nil)
        fontPicker.delegate = self
        present(UINavigationController(rootViewController: fontPicker), animated: true)
    }
}

extension LabelAttributesViewController: FontSelectorDelegate {
    
    func didSelectFont(_ font: UIFont) {
        kLabel.font = font
    }
    
}

extension LabelAttributesViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        dismiss(animated: true, completion: nil)
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        switch viewController {
        case textColorPicker:
            textColor = selectedColor
        case outlineColorPicker:
            outlineColor = selectedColor
        default:
            break
        }
    }
}

enum ColorType {
    case outline
    case text
}
