import UIKit

public final class SnackbarOverlayWindow: UIWindow {
    // MARK: - Properties
    private lazy var containerView: SnackbarOverlayWindowContainerView = {
        let containerView = SnackbarOverlayWindowContainerView()
        containerView.backgroundColor = .clear
        return containerView
    }()
    private var snackbarOverlayView: UIView?

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

    // MARK: - Window
    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        bringSubviewToFront(containerView)
    }

    // MARK: - Overlay
    func activeOverlay(_ overlayView: UIView) {
        overlayView.removeFromSuperview()

        containerView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                                     overlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
                                     overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                                     overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)])
        snackbarOverlayView = overlayView

        updateOverlayHiddenState()
    }

    func deactiveOverlay(_ overlayView: UIView) {
        guard overlayView == snackbarOverlayView else { return }

        snackbarOverlayView = nil

        updateOverlayHiddenState()
    }

    private func updateOverlayHiddenState() {
        containerView.isHidden = (snackbarOverlayView == nil)
    }
}
