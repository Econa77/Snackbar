import UIKit

struct SnackbarQueue: Equatable {
    // MARK: - Properties
    let uuid: UUID
    let message: SnackbarMessage
    private(set) weak var presentationHostView: UIView?

    // MARK: - Initialize
    init(uuid: UUID = .init(), message: SnackbarMessage, presentationHostView: UIView) {
        self.uuid = uuid
        self.message = message
        self.presentationHostView = presentationHostView
    }

    // MARK: - Equatable
    static func == (lhs: SnackbarQueue, rhs: SnackbarQueue) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
