import UIKit

class PlaybackControlsView: UIView {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16.0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        return button
    }()

    let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pause", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        return button
    }()

    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        return button
    }()

    // Closures for button actions
    var playAction: (() -> Void)?
    var pauseAction: (() -> Void)?
    var resetAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupActions()
    }

    private func setupUI() {
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(pauseButton)
        stackView.addArrangedSubview(resetButton)

        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func setupActions() {
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonPressed), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
    }

    // Button action methods
    @objc private func playButtonPressed() {
        playAction?()
    }

    @objc private func pauseButtonPressed() {
        pauseAction?()
    }

    @objc private func resetButtonPressed() {
        resetAction?()
    }
}
