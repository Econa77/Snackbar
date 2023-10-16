import UIKit

final class SnackbarMessageView: UIView {
    // MARK: - Properties
    let message: SnackbarMessage

    private var dissmissHandler: ((SnackbarAction?, Bool) -> Void)?

    // MARK: - Initialize
    init(message: SnackbarMessage, dismissHandler: @escaping ((SnackbarAction?, Bool) -> Void)) {
        self.message = message
        self.dissmissHandler = dismissHandler
        super.init(frame: .zero)
        // Styling
        backgroundColor = message.style.backgroundColor
        layer.cornerRadius = message.style.cornerRadius
        layer.shadowColor = message.style.shadowColor.cgColor
        layer.shadowOpacity = message.style.shadowOpacity
        layer.shadowOffset = message.style.shadowOffset
        layer.shadowRadius = message.style.shadowRadius
        // Content
        let containerview = UIControl()
        containerview.backgroundColor = .clear
        containerview.layer.cornerRadius = message.style.cornerRadius
        addSubview(containerview)
        containerview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([containerview.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     containerview.topAnchor.constraint(equalTo: topAnchor),
                                     containerview.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     containerview.bottomAnchor.constraint(equalTo: bottomAnchor)])
        containerview.addTarget(self, action: #selector(self.handleBackgroundTapped), for: .touchUpInside)
        // Mesagge
        let messageLabel = UILabel()
        messageLabel.attributedText = message.messageAttributedString
        messageLabel.textColor = message.textColor
        messageLabel.font = message.font
        messageLabel.numberOfLines = message.numberOfLines
        messageLabel.isUserInteractionEnabled = false
        messageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        // Layout
        if message.action != nil || message.isCloseButtonEnabled {
            addSubview(messageLabel)
            NSLayoutConstraint.activate(
                [messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                 messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                 messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)]
            )
            // Buttons
            let buttonStackView = UIStackView()
            buttonStackView.axis = .horizontal
            buttonStackView.alignment = .center
            buttonStackView.spacing = 4
            buttonStackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(buttonStackView)
            NSLayoutConstraint.activate(
                [buttonStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 4),
                 buttonStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4),
                 buttonStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                 buttonStackView.leadingAnchor.constraint(greaterThanOrEqualTo: messageLabel.trailingAnchor, constant: 4),
                 buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: (message.isCloseButtonEnabled) ? -4 : -8)]
            )
            if let action = message.action {
                let actionButton = UIButton(type: .system)
                actionButton.setTitleColor(action.textColor, for: .normal)
                actionButton.titleLabel?.font = action.font
                actionButton.setAttributedTitle(action.titleAttributedString, for: .normal)
                actionButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
                actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
                actionButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                actionButton.translatesAutoresizingMaskIntoConstraints = false
                actionButton.addTarget(self, action: #selector(self.handleButtonTapped), for: .touchUpInside)
                buttonStackView.addArrangedSubview(actionButton)
            }
            if message.isCloseButtonEnabled {
                let closeButton = UIButton(type: .system)
                closeButton.tintColor = message.closeButtonTintColor
                closeButton.setImage(UIImage(named: "ic_close", in: .current, compatibleWith: nil), for: .normal)
                buttonStackView.translatesAutoresizingMaskIntoConstraints = false
                closeButton.addTarget(self, action: #selector(self.handleCloseButtonTapped), for: .touchUpInside)
                buttonStackView.addArrangedSubview(closeButton)
                NSLayoutConstraint.activate(
                    [closeButton.widthAnchor.constraint(equalToConstant: 40),
                     closeButton.heightAnchor.constraint(equalToConstant: 40)]
                )
            }
        } else {
            addSubview(messageLabel)
            NSLayoutConstraint.activate(
                [messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                 messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                 messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                 messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)]
            )
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func dismiss(with action: SnackbarAction?, isUserInitiated: Bool) {
        guard let dissmissHandler = dissmissHandler else { return }
        dissmissHandler(action, isUserInitiated)
        self.dissmissHandler = nil
    }

    @objc private func handleBackgroundTapped() {
        dismiss(with: nil, isUserInitiated: true)
    }

    @objc private func handleCloseButtonTapped() {
        dismiss(with: nil, isUserInitiated: true)
    }

    @objc private func handleButtonTapped() {
        dismiss(with: message.action, isUserInitiated: true)
    }
}
