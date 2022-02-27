import UIKit

public struct SnackbarShadow {
    // MARK: - Properties
    public let color: UIColor
    public let opacity: Float
    public let offset: CGSize
    public let radius: CGFloat

    // MARK: - Initialize
    init(color: UIColor = .clear, opacity: Float = 0, offset: CGSize = .init(width: 0, height: -3), radius: CGFloat = 3) {
        self.color = color
        self.opacity = opacity
        self.offset = offset
        self.radius = radius
    }
}
