import UIKit

public struct Configuration {

}

public extension Configuration {
    enum Alignment {
        case center
        case leading
    }
}

public extension Configuration {
    // ref: https://stackoverflow.com/a/56598682
    enum Duration {
        case short
        case long
        case indefinite
        case custom(CGFloat)

        // MARK: - Properties
        var value: CGFloat {
            switch self {
            case .short:
                return 1.5
            case .long:
                return 2.75
            case .indefinite:
                return -1
            case .custom(let value):
                return value
            }
        }
    }
}
