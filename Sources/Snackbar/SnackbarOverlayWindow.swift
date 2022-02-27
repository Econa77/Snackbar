import UIKit

/// Customizing the Window to always show the View on all sides addresses the problem of modals appearing and the snack bar disappearing.
/// ref: https://github.com/material-components/material-components-ios/blob/51aa24305cde2bd26b614a2b05f730fe71266e2e/components/OverlayWindow/src/MDCOverlayWindow.m
public final class SnackbarOverlayWindow: UIWindow {
    // MARK: - Properties
    private lazy var containerView: SnackbarOverlayWindowContainerView = {
        let containerView = SnackbarOverlayWindowContainerView()
        containerView.backgroundColor = .clear
        return containerView
    }()
    private var overlayViews = [Overlay]()

    // MARK: - Initialize
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    @available(iOS 13.0, *)
    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        initView()
    }

    private func initView() {
        backgroundColor = .clear

        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     containerView.topAnchor.constraint(equalTo: topAnchor),
                                     containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     containerView.bottomAnchor.constraint(equalTo: bottomAnchor)])

        updateOverlayHiddenState()
    }

    // MARK: - Window Positioning
    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        bringSubviewToFront(containerView)
    }

    // MARK: - Overlay
    func activeOverlay(_ overlayView: UIView, windowLevel: UIWindow.Level) {
        overlayView.removeFromSuperview()

        let insertionIndex = overlayViews.firstIndex(where: { windowLevel < $0.windowLevel }) ?? overlayViews.count
        containerView.insertSubview(overlayView, at: insertionIndex)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                                     overlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
                                     overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                                     overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)])
        overlayViews.insert(.init(view: overlayView, windowLevel: windowLevel), at: insertionIndex)

        updateOverlayHiddenState()
    }

    func deactiveOverlay(_ overlayView: UIView) {
        guard overlayViews.contains(where: { $0.view == overlayView }) else { return }

        // When the View is removed here, `noteOverlayRemoved()` will be called from `SnapbarOverlayWindowContainerView`.
        overlayView.removeFromSuperview()
    }

    func noteOverlayRemoved(_ overlayView: UIView) {
        guard overlayViews.contains(where: { $0.view == overlayView }) else { return }

        overlayViews.removeAll(where: { $0.view == overlayView })

        updateOverlayHiddenState()
    }

    private func updateOverlayHiddenState() {
        containerView.isHidden = overlayViews.isEmpty
    }
}

private extension SnackbarOverlayWindow {
    struct Overlay {
        // MARK: - Properties
        let view: UIView
        let windowLevel: UIWindow.Level
    }
}
