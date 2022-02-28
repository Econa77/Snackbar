import UIKit

public struct SnackbarAction {
    // MARK: - Properties
    public let titleAttributedString: NSAttributedString
    public let font: UIFont
    public let textColor: UIColor
    public let handler: (() -> Void)

    // MARK: - Initialize
    public init(title: String, font: UIFont = .systemFont(ofSize: 14), textColor: UIColor = .white.withAlphaComponent(0.6), handler: @escaping (() -> Void)) {
        self.titleAttributedString = NSAttributedString(string: title,
                                                        attributes: [.font: font,
                                                                     .foregroundColor: textColor])
        self.font = font
        self.textColor = textColor
        self.handler = handler
    }

    public init(titleAttributedString: NSAttributedString, handler: @escaping (() -> Void)) {
        self.titleAttributedString = titleAttributedString
        self.font = .systemFont(ofSize: 14)
        self.textColor = .white.withAlphaComponent(0.6)
        self.handler = handler
    }
}
