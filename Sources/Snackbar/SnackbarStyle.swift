import UIKit

public struct SnackbarStyle {
    // MARK: - Properties
    public let backgroundColor: UIColor
    public let cornerRadius: CGFloat
    public let shadowColor: UIColor
    public let shadowOpacity: Float
    public let shadowOffset: CGSize
    public let shadowRadius: CGFloat

    // MARK: - Initialize
    public init(backgroundColor: UIColor = UIColor(white: 0.1961, alpha: 1), cornerRadius: CGFloat = 4, shadowColor: UIColor = .clear, shadowOpacity: Float = 0, shadowOffset: CGSize = .zero, shadowRadius: CGFloat = 0) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
    }
}
