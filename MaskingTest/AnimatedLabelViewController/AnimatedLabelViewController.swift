
import UIKit

class AnimatedLabelViewController: UIViewController {
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var animatedLabel: AnimatedLabel = {
        let label = AnimatedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var normalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var sliderView: SliderView = {
        let sliderView = SliderView()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.delegate = self
        sliderView.totalDuration = 120.0
        sliderView.currentTime = 0.0
        return sliderView
    }()
    
    private lazy var playbackView: PlaybackControlsView = {
        let playbackView = PlaybackControlsView()
        return playbackView
    }()
    
    private lazy var granularitySegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Character", "Word", "Full"])
        segmentedControl.selectedSegmentIndex = 1 // Default selection to "Character"
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    private var startTime: Date?
    private var pausedTime: TimeInterval?
    private var currentTime: TimeInterval = 0.0 {
        didSet {
            self.pausedTime = currentTime
            currentTimeDidChange()
        }
    }
    
    private let maxTime: TimeInterval = 120.0
    
    private var displayText: String = "REELS GOT RIZZ" {
        didSet {
            updateDisplayTextLabels()
        }
    }
    
    private let oscillator = Oscillator(minValue: 0.0, maxValue: 60, period: 2)
    
    private func updateDisplayTextLabels() {
        let attr = NSAttributedString(string: displayText, attributes: [
//            .strokeColor : UIColor.red,
//            .strokeWidth : -3.0,
            .foregroundColor: UIColor.black,
            .font : UIFont(name: "AvenirNext-Regular", size: 35)!
        ])
        animatedLabel.attributedText = attr
        normalLabel.attributedText = attr
        
//        animatedLabel.text = displayText
//        normalLabel.text = displayText
    }
    
    private var wasPlayingWhenAdjustedSlider: Bool?
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(verticalStackView)
        
        defer {
            verticalStackView.addArrangedSubview(UIView())
        }
        
        verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        verticalStackView.addArrangedSubview(animatedLabel)
        verticalStackView.addArrangedSubview(normalLabel)
        verticalStackView.addArrangedSubview(textField)
        verticalStackView.addArrangedSubview(sliderView)
        verticalStackView.addArrangedSubview(playbackView)
        verticalStackView.addArrangedSubview(granularitySegment)
        
        sliderView.totalDuration = maxTime
        animatedLabel.animationDuration = maxTime
        
        configureLabel(label: animatedLabel)
        configureLabel(label: normalLabel)
        
        playbackView.playAction = {
            self.startPlaying()
        }
        
        playbackView.pauseAction = {
            if let startTime = self.startTime {
                self.pausedTime = Date().timeIntervalSince(startTime)
            }
            self.startTime = nil
            self.timer?.invalidate()
            self.timer = nil
        }
        
        playbackView.resetAction = {
            self.pausedTime = nil
            self.startTime = nil
            self.currentTime = 0.0
            self.timer?.invalidate()
            self.timer = nil
        }
        
        startPlaying()
    }
    
    private func startPlaying() {
        var newTime = Date()
        if let pausedTime = self.pausedTime {
            newTime = Date().addingTimeInterval(-pausedTime)
        }
        self.startTime = newTime
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.timerWasCalled), userInfo: nil, repeats: true)
    }
    
    @objc private func timerWasCalled() {
        if let startTime {
            let proposedTime = Date().timeIntervalSince(startTime)
            if proposedTime > maxTime {
                self.startTime = Date()
                self.currentTime = proposedTime.truncatingRemainder(dividingBy: maxTime)
            } else {
                self.currentTime = proposedTime
            }
        }
    }
    
    private func configureLabel(label: UILabel) {
        label.heightAnchor.constraint(equalToConstant: 150).isActive = true
        label.backgroundColor = .black
        label.numberOfLines = 0
        label.textColor = .white
//        label.shadowColor = .black
//        label.shadowOffset = CGSize(width: 1, height: 1)
        label.textAlignment = .center
        updateDisplayTextLabels()
    }
    
    private func currentTimeDidChange() {
        animatedLabel.currentTime = self.currentTime
        sliderView.currentTime = self.currentTime
        animatedLabel.neonOutlineRadius = oscillator.oscillate(timeInterval: currentTime)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            animatedLabel.granularity = .character
        case 1:
            animatedLabel.granularity = .word
        case 2:
            animatedLabel.granularity = .full
        default:
            break
        }
    }
    
}

extension AnimatedLabelViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let newText = textField.text {
            displayText = newText
        }
    }
    
}


extension AnimatedLabelViewController: SliderViewDelegate {
    
    func sliderView(_ sliderView: SliderView, didChangeCurrentTime currentTime: TimeInterval) {
//        let zoomVal = zoomSeed.randomNumber(timeInterval: currentTime)
//        zoomBlur.inputAmount = zoomVal
//        zoomBlurStepper.valueLabelFloat = zoomVal
//
//        let boxVal = boxSeed.randomNumber(timeInterval: currentTime)
//        boxBlur.inputRadius = boxVal
//        boxBlurStepper.valueLabelFloat = boxVal
//
//        let motionVal = motionSeed.randomNumber(timeInterval: currentTime)
//        motionBlur.inputRadius = motionVal
//        motionBlurStepper.valueLabelFloat = motionVal
        
//        bumpRadius = bumpRadiusSeed.randomNumber(timeInterval: currentTime)
//        
//        bumpX = bumpCenterXSeed.randomNumber(timeInterval: currentTime)
//        bumpY = bumpCenterYSeed.randomNumber(timeInterval: currentTime)
//    
//        let bumpVal4 = bumpScaleSeed.randomNumber(timeInterval: currentTime)
//        bumpDistortion.inputScale = bumpVal4
//        bumpDistortionInputScaleStepper.valueLabelFloat = bumpVal4
        
//        print("Current Time: \(currentTime), zoomVal: \(zoomVal), boxVal: \(boxVal), motionVal: \(motionVal)")
//        let val = oscillator.oscillate(timeInterval: currentTime)
//        print("val: \(val)")
        
//        self.pausedTime = nil
        self.startTime = nil
        self.timer?.invalidate()
        self.timer = nil
        self.currentTime = currentTime
    }
    
    func sliderViewDidReleaseGrip(_ sliderView: SliderView) {
        if let wasPlayingWhenAdjustedSlider, wasPlayingWhenAdjustedSlider {
            startPlaying()
        }
        wasPlayingWhenAdjustedSlider = nil
    }
    
    func sliderViewWasTouched(_ sliderView: SliderView) {
        wasPlayingWhenAdjustedSlider = timer != nil
    }
    
}
