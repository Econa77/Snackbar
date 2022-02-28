import UIKit

public final class Snackbar {
    // MARK: - Properties
    public static var `shared` = Snackbar()

    public private(set) var alignment: SnackbarAlignment = .center
    public private(set) var leadingMargin: CGFloat = 16
    public private(set) var trailingMargin: CGFloat = 16
    public private(set) var bottomOffset: CGFloat = 16

    private var isDismissingMessage = false
    private var pendingQueues = [SnackbarQueue]()
    private var overlayViews = [SnackbarOverlayView]()

    // MARK: - Initialize
    init() {}

    public func showMessage(_ message: SnackbarMessage, presentationHostView: UIView) {
        assert(Thread.isMainThread, "Method is not called on main thread.")
        pendingQueues.append(.init(message: message, presentationHostView: presentationHostView))
        showNextMessageIfNecessary()
    }

    public func setAlignment(_ alignment: SnackbarAlignment) {
        assert(Thread.isMainThread, "setAlignment must be called on main thread.")
        self.alignment = alignment
        overlayViews.forEach { $0.setAlignment(alignment) }
    }

    public func setLeadingMargin(_ leadingMargin: CGFloat) {
        assert(Thread.isMainThread, "setLeadingMargin must be called on main thread.")
        self.leadingMargin = leadingMargin
        overlayViews.forEach { $0.setLeadingMargin(leadingMargin) }
    }

    public func setTrailingMargin(_ trailingMargin: CGFloat) {
        assert(Thread.isMainThread, "setTrailingMargin must be called on main thread.")
        self.trailingMargin = trailingMargin
        overlayViews.forEach { $0.setTrailingMargin(trailingMargin) }
    }

    public func setBottomOffset(_ bottomOffset: CGFloat) {
        assert(Thread.isMainThread, "setBottomOffset must be called on main thread.")
        self.bottomOffset = bottomOffset
        overlayViews.forEach { $0.setBottomOffset(bottomOffset) }
    }
}

private extension Snackbar {
    func showNextMessageIfNecessary() {
        assert(Thread.isMainThread, "Method is not called on main thread.")
        guard let nextQueue = pendingQueues.first else { return }
        guard let presentationHostView = nextQueue.presentationHostView else {
            pendingQueues.removeAll(where: { $0 == nextQueue })
            showNextMessageIfNecessary()
            return
        }
        guard let overlayView = overlay(for: presentationHostView) else {
            pendingQueues.removeAll(where: { $0 == nextQueue })
            displaySnackbarView(for: nextQueue.message, presentationHostView: presentationHostView)
            return
        }
        overlayView.currentSnackbarView?.dismiss(with: nil, isUserInitiated: false)
    }

    func displaySnackbarView(for message: SnackbarMessage, presentationHostView: UIView) {
        let overlayView = SnackbarOverlayView(alignment: alignment, leadingMargin: leadingMargin, trailingMargin: trailingMargin, bottomOffset: bottomOffset)
        overlayView.backgroundColor = .clear
        activateOverlay(overlayView, presentationHostView: presentationHostView)

        let snackbarView = SnackbarMessageView(message: message) { [weak overlayView, weak presentationHostView] action, _ in
            if let action = action {
                DispatchQueue.main.async { action.handler() }
            }
            overlayView?.dismissSnackbarView(animated: true) { [weak self, weak overlayView, weak presentationHostView] in
                guard let overlayView = overlayView, let presentationHostView = presentationHostView else {
                    self?.showNextMessageIfNecessary()
                    return
                }
                self?.deactivateOverlay(overlayView, presentationHostView: presentationHostView)
                self?.showNextMessageIfNecessary()
            }
        }
        overlayView.displaySnackbarView(snackbarView, animated: true) { [weak snackbarView] in
            guard let automaticallyDismissesDuration = message.duration.value else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + automaticallyDismissesDuration) { [weak snackbarView] in
                snackbarView?.dismiss(with: nil, isUserInitiated: false)
            }
        }
    }

    func overlay(for presentationHostView: UIView) -> SnackbarOverlayView? {
        if let overlayWindow = presentationHostView as? SnackbarOverlayWindow {
            return overlayWindow.overlayView
        } else {
            return presentationHostView.subviews.first(where: { $0 is SnackbarOverlayView }) as? SnackbarOverlayView
        }
    }

    func activateOverlay(_ overlayView: SnackbarOverlayView, presentationHostView: UIView) {
        if let overlayWindow = presentationHostView as? SnackbarOverlayWindow {
            overlayWindow.activeOverlay(overlayView)
        } else {
            presentationHostView.addSubview(overlayView)
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([overlayView.leadingAnchor.constraint(equalTo: presentationHostView.leadingAnchor),
                                         overlayView.topAnchor.constraint(equalTo: presentationHostView.topAnchor),
                                         overlayView.trailingAnchor.constraint(equalTo: presentationHostView.trailingAnchor),
                                         overlayView.bottomAnchor.constraint(equalTo: presentationHostView.bottomAnchor)])
        }
        overlayViews.append(overlayView)
    }

    func deactivateOverlay(_ overlayView: SnackbarOverlayView, presentationHostView: UIView) {
        if let overlayWindow = presentationHostView as? SnackbarOverlayWindow {
            overlayWindow.deactiveOverlay(overlayView)
        } else {
            overlayView.removeFromSuperview()
        }
        overlayViews.removeAll(where: { $0 == overlayView })
    }
}
