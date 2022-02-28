import UIKit

public struct SnackbarMessage {
    // MARK: - Properties
    public let messageAttributedString: NSAttributedString
    public let font: UIFont
    public let textColor: UIColor
    public let style: SnackbarStyle
    public let duration: SnackbarDuration
    public let action: SnackbarAction?

    // MARK: - Initialize
    public init(message: String, font: UIFont = .systemFont(ofSize: 14), textColor: UIColor = .white, style: SnackbarStyle = .init(), duration: SnackbarDuration = .long, action: SnackbarAction? = nil) {
        self.messageAttributedString = NSAttributedString(string: message,
                                                          attributes: [.font: font,
                                                                       .foregroundColor: textColor])
        self.font = font
        self.textColor = textColor
        self.style = style
        self.duration = duration
        self.action = action
    }

    public init(messageAttributedString: NSAttributedString, style: SnackbarStyle = .init(), duration: SnackbarDuration = .long, action: SnackbarAction? = nil) {
        self.messageAttributedString = messageAttributedString
        self.font = .systemFont(ofSize: 14)
        self.textColor = .white
        self.style = style
        self.duration = duration
        self.action = action
    }
}
