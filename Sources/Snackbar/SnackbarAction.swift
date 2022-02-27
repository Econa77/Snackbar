import UIKit

public struct SnackbarAction {
    // MARK: - Properties
    public let titleAttributedString: NSAttributedString
    public let handler: (() -> Void)

    // MARK: - Initialize
    init(title: String, font: UIFont = .systemFont(ofSize: 14), textColor: UIColor = .white.withAlphaComponent(0.6), handler: @escaping (() -> Void)) {
        let titleAttributedString = NSAttributedString(string: title,
                                                       attributes: [.font: font,
                                                                    .foregroundColor: textColor])
        self.init(titleAttributedString: titleAttributedString, handler: handler)
    }

    init(titleAttributedString: NSAttributedString, handler: @escaping (() -> Void)) {
        self.titleAttributedString = titleAttributedString
        self.handler = handler
    }
}
