import Foundation

// ref: https://stackoverflow.com/a/56598682
public enum SnackbarDuration {
    case short
    case long
    case indefinite
    case custom(DispatchTimeInterval)

    // MARK: - Properties
    var value: DispatchTimeInterval? {
        switch self {
        case .short:
            return .milliseconds(1500)
        case .long:
            return .milliseconds(2750)
        case .indefinite:
            return nil
        case .custom(let value):
            return value
        }
    }
}
