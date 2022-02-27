import UIKit

public struct SnackbarMessage {
    // MARK: - Properties
    public let messageAttributedString: NSAttributedString
    public let backgroundColor: UIColor
    public let shadow: SnackbarShadow
    public let duration: Configuration.Duration
    public let action: SnackbarAction?

    // MARK: - Initialize
    init(message: String, font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = .white, backgroundColor: UIColor = UIColor(white: 0.1961, alpha: 1), shadow: SnackbarShadow = .init(), duration: Configuration.Duration = .long, action: SnackbarAction? = nil) {
        let messageAttributedString = NSAttributedString(string: message,
                                                         attributes: [.font: font,
                                                                      .foregroundColor: textColor])
        self.init(messageAttributedString: messageAttributedString, backgroundColor: backgroundColor, shadow: shadow, duration: duration, action: action)
    }

    init(messageAttributedString: NSAttributedString, backgroundColor: UIColor = UIColor(white: 0.1961, alpha: 1), shadow: SnackbarShadow = .init(), duration: Configuration.Duration = .long, action: SnackbarAction? = nil) {
        self.messageAttributedString = messageAttributedString
        self.backgroundColor = backgroundColor
        self.shadow = shadow
        self.duration = duration
        self.action = action
    }
}
