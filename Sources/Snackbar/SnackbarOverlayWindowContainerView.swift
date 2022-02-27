import UIKit

final class SnackbarOverlayWindowContainerView: UIView {
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        (window as? SnackbarOverlayWindow)?.noteOverlayRemoved(subview)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return (hitView == self) ? nil : hitView
    }
}
