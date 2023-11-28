
import UIKit

protocol SliderViewDelegate: AnyObject {
    func sliderView(_ sliderView: SliderView, didChangeCurrentTime currentTime: TimeInterval)
    func sliderViewDidReleaseGrip(_ sliderView: SliderView)
    func sliderViewWasTouched(_ sliderView: SliderView)
}

class SliderView: UIView {
    weak var delegate: SliderViewDelegate?

    private let slider = UISlider()
    private let currentTimeLabel = UILabel()
    private let totalTimeLabel = UILabel()

    var totalDuration: TimeInterval = 120 {
        didSet {
            updateTotalTimeLabel()
            slider.maximumValue = Float(totalDuration)
        }
    }

    var currentTime: TimeInterval {
        get {
            return TimeInterval(slider.value)
        }
        set {
            slider.value = Float(newValue)
            updateCurrentTimeLabel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        // Slider
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.isUserInteractionEnabled = true
//        slider.minimumValue = 0
//        slider.maximumValue = 1000
        slider.isContinuous = true
        slider.tintColor = UIColor.blue
//        slider.value = 500
        
        addSubview(slider)

        // Current Time Label
        currentTimeLabel.textColor = .black
        addSubview(currentTimeLabel)

        // Total Time Label
        totalTimeLabel.textColor = .black
        addSubview(totalTimeLabel)

        // Layout
        slider.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: topAnchor),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),

            currentTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 8),
            currentTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            totalTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 8),
            totalTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        slider.addTarget(self, action: #selector(sliderTouchUpInside), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderFirstTouch), for: .touchDown)

    }

    private func updateCurrentTimeLabel() {
        currentTimeLabel.text = formattedTime(currentTime)
    }

    private func updateTotalTimeLabel() {
        totalTimeLabel.text = formattedTime(totalDuration)
    }
    
    override var intrinsicContentSize: CGSize {
        let sliderSize = slider.intrinsicContentSize
        let labelsSize = CGSize(width: max(currentTimeLabel.intrinsicContentSize.width, totalTimeLabel.intrinsicContentSize.width), height: max(currentTimeLabel.intrinsicContentSize.height, totalTimeLabel.intrinsicContentSize.height))

        let width = max(sliderSize.width, labelsSize.width)
        let height = sliderSize.height + labelsSize.height + 8  // Add spacing between slider and labels

        return CGSize(width: width, height: height)
    }

    private func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 1000)

        return String(format: "%02d:%02d:%03d", minutes, seconds, milliseconds)
    }

    @objc private func sliderValueChanged(_ sender: UISlider) {
        updateCurrentTimeLabel()
        delegate?.sliderView(self, didChangeCurrentTime: TimeInterval(sender.value))
    }
    
    @objc private func sliderFirstTouch() {
        delegate?.sliderViewWasTouched(self)
    }
    
    @objc private func sliderTouchUpInside() {
        delegate?.sliderViewDidReleaseGrip(self)
    }
    
}
