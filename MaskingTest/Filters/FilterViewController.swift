//
//  FilterViewController.swift
//  MaskingTest
//
//  Created by Kyle Kendall on 11/10/23.
//

import UIKit
import GameKit

private let labelHeight: CGFloat = 150

class FilterViewController: UIViewController {
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var zoomBlur: CIFilter.ZoomBlur = CIFilter.ZoomBlur()
    private var boxBlur: CIFilter.BoxBlur = CIFilter.BoxBlur.standard
    private var motionBlur: CIFilter.MotionBlur = CIFilter.MotionBlur.standard
    private var bumpDistortion: CIFilter.BumpDistortion = CIFilter.BumpDistortion.standard
    
    private var zoomSeed = PredictableRandomNumberGenerator(minValue: 0, maxValue: 7.0, primarySeed: 1)
    private var boxSeed = PredictableRandomNumberGenerator(minValue: 0, maxValue: 8.0, primarySeed: 2)
    private var motionSeed = PredictableRandomNumberGenerator(minValue: 0, maxValue: 9.0, primarySeed: 3)
    private var bumpCenterXSeed = PredictableRandomNumberGenerator(minValue: 0, maxValue: 320, primarySeed: 5)
    private var bumpCenterYSeed = PredictableRandomNumberGenerator(minValue: 0, maxValue: labelHeight, primarySeed: 6)
    private var bumpRadiusSeed = PredictableRandomNumberGenerator(minValue: 0, maxValue: 40, primarySeed: 7)
    private var bumpScaleSeed = PredictableRandomNumberGenerator(minValue: 0, maxValue: 1.0, primarySeed: 8)
    
    private lazy var filterLabel: FilterLabel = {
        let label = FilterLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.blurTypes = [zoomBlur, boxBlur, motionBlur, bumpDistortion]
        label.numberOfLines = 0
        let text = "Here is a test And a loooooooooooong one with h h f e w t j k lo i f d s g h k k"
        label.text = text
        label.font = UIFont.systemFont(ofSize: 35)
        return label
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "hills")
        return imageView
    }()
    
    private lazy var zoomBlurStepper: StepperAndLabelView = {
        let stepper = StepperAndLabelView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.displayLabel.text = "ZoomBlur input amount:"
        stepper.didChangeValue = { newValue in
            self.zoomBlur.inputAmount = newValue
        }
        return stepper
    }()
    
    private lazy var boxBlurStepper: StepperAndLabelView = {
        let stepper = StepperAndLabelView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.displayLabel.text = "Box Blur input radius:"
        stepper.didChangeValue = { newValue in
            self.boxBlur.inputRadius = newValue
        }
        return stepper
    }()
    
    private lazy var motionBlurStepper: StepperAndLabelView = {
        let stepper = StepperAndLabelView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.displayLabel.text = "Motion Blur input radius:"
        stepper.didChangeValue = { newValue in
            self.motionBlur.inputRadius = newValue
        }
        return stepper
    }()
    
    private lazy var bumpDistortionCenterXStepper: StepperAndLabelView = {
        let stepper = StepperAndLabelView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.displayLabel.text = "Bump X:"
        stepper.didChangeValue = { newValue in
            self.bumpX = newValue
        }
        stepper.stepper.stepValue = 10
        stepper.stepper.maximumValue = 100000
        stepper.stepper.minimumValue = -100000
        return stepper
    }()
    
    private lazy var bumpDistortionCenterYStepper: StepperAndLabelView = {
        let stepper = StepperAndLabelView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.displayLabel.text = "Bump Y:"
        stepper.didChangeValue = { newValue in
            self.bumpY = newValue
        }
        stepper.stepper.stepValue = 10
        stepper.stepper.maximumValue = 100000
        stepper.stepper.minimumValue = -100000
        return stepper
    }()
    
    private lazy var bumpDistortionInputRadiusStepper: StepperAndLabelView = {
        let stepper = StepperAndLabelView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.displayLabel.text = "Bump radius:"
        stepper.didChangeValue = { newValue in
            self.bumpDistortion.inputRadius = newValue
        }
        stepper.stepper.stepValue = 10
        stepper.stepper.maximumValue = 100000
        return stepper
    }()
    
    private lazy var bumpDistortionInputScaleStepper: StepperAndLabelView = {
        let stepper = StepperAndLabelView()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.displayLabel.text = "Bump scale:"
        stepper.didChangeValue = { newValue in
            self.bumpDistortion.inputScale = newValue
        }
        stepper.stepper.maximumValue = 1.0
        stepper.stepper.minimumValue = 0.0
        stepper.stepper.stepValue = 0.1
        return stepper
    }()
    
    private lazy var sliderView: SliderView = {
        let sliderView = SliderView()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.delegate = self
        sliderView.totalDuration = 120.0
        sliderView.currentTime = 0.0
        return sliderView
    }()
    
    var bumpX: Double = 150 {
        didSet {
            bumpDistortion.inputCenter = CIVector(x: bumpX, y: bumpY)
            bumpDistortionCenterXStepper.valueLabelFloat = bumpX
        }
    }
    
    var bumpY: Double = 150 {
        didSet {
            bumpDistortion.inputCenter = CIVector(x: bumpX, y: bumpY)
            bumpDistortionCenterYStepper.valueLabelFloat = bumpY
        }
    }
    
    var bumpRadius: Double = 30 {
        didSet {
            bumpDistortion.inputRadius = bumpRadius
            bumpDistortionInputRadiusStepper.valueLabelFloat = bumpRadius
            
            bumpCenterXSeed.maxValue = filterLabel.frame.width - bumpRadius
            bumpCenterXSeed.minValue = bumpRadius
            bumpCenterYSeed.maxValue = filterLabel.frame.height - bumpRadius
            bumpCenterYSeed.minValue = bumpRadius
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImageView)
        
        view.addSubview(verticalStackView)
        defer {
            verticalStackView.addArrangedSubview(UIView())
        }
        
        verticalStackView.addArrangedSubview(filterLabel)
        verticalStackView.addArrangedSubview(zoomBlurStepper)
        verticalStackView.addArrangedSubview(boxBlurStepper)
        verticalStackView.addArrangedSubview(motionBlurStepper)
        verticalStackView.addArrangedSubview(bumpDistortionCenterXStepper)
        verticalStackView.addArrangedSubview(bumpDistortionCenterYStepper)
        verticalStackView.addArrangedSubview(bumpDistortionInputRadiusStepper)
        verticalStackView.addArrangedSubview(bumpDistortionInputScaleStepper)
        
        verticalStackView.addArrangedSubview(sliderView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            filterLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            backgroundImageView.topAnchor.constraint(equalTo: filterLabel.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: filterLabel.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: filterLabel.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: filterLabel.bottomAnchor),
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
}

extension FilterViewController: SliderViewDelegate {
    func sliderViewDidReleaseGrip(_ sliderView: SliderView) {
        
    }
    
    func sliderViewWasTouched(_ sliderView: SliderView) {
        
    }
    
    
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
        
        bumpRadius = bumpRadiusSeed.randomNumber(timeInterval: currentTime)
        
        bumpX = bumpCenterXSeed.randomNumber(timeInterval: currentTime)
        bumpY = bumpCenterYSeed.randomNumber(timeInterval: currentTime)
    
        let bumpVal4 = bumpScaleSeed.randomNumber(timeInterval: currentTime)
        bumpDistortion.inputScale = bumpVal4
        bumpDistortionInputScaleStepper.valueLabelFloat = bumpVal4
        
//        print("Current Time: \(currentTime), zoomVal: \(zoomVal), boxVal: \(boxVal), motionVal: \(motionVal)")
    }
    
}
