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
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.numberOfLines = 2
        messageLabel.isUserInteractionEnabled = false
        messageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        // Layout
        if let action = message.action {
            addSubview(messageLabel)
            NSLayoutConstraint.activate([messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                                         messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                                         messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)])

            let actionButton = UIButton(type: .system)
            actionButton.setTitleColor(action.textColor, for: .normal)
            actionButton.titleLabel?.font = action.font
            actionButton.setAttributedTitle(action.titleAttributedString, for: .normal)
            actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
            actionButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            actionButton.addTarget(self, action: #selector(self.handleButtonTapped), for: .touchUpInside)
            addSubview(actionButton)
            NSLayoutConstraint.activate([actionButton.topAnchor.constraint(equalTo: topAnchor),
                                         actionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                                         actionButton.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8),
                                         actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)])
        } else {
            addSubview(messageLabel)
            NSLayoutConstraint.activate([messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                                         messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                                         messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                                         messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)])
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

    @objc private func handleButtonTapped() {
        dismiss(with: message.action, isUserInitiated: true)
    }
}
