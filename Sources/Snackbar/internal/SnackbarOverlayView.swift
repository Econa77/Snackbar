import UIKit

final class SnackbarOverlayView: UIView {
    // MARK: - Properties
    private(set) var currentSnackbarView: SnackbarMessageView?

    private var alignment: SnackbarAlignment
    private var leadingMargin: CGFloat
    private var trailingMargin: CGFloat
    private var bottomOffset: CGFloat
    private var snackbarViewAlignmentLeadingConstraint: NSLayoutConstraint?
    private var snackbarViewAlignmentCenterConstarint: NSLayoutConstraint?
    private var snackbarViewLeadingConstraint: NSLayoutConstraint?
    private var snackbarViewTrailingConstraint: NSLayoutConstraint?
    private var snackbarViewBottomConstraint: NSLayoutConstraint?

    // MARK: - Initialize
    init(alignment: SnackbarAlignment, leadingMargin: CGFloat, trailingMargin: CGFloat, bottomOffset: CGFloat) {
        self.alignment = alignment
        self.leadingMargin = leadingMargin
        self.trailingMargin = trailingMargin
        self.bottomOffset = bottomOffset
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func displaySnackbarView(_ snackbarView: SnackbarMessageView, animated: Bool, completion: @escaping (() -> Void)) {
        addSnackbarView(snackbarView)
        if animated {
            slideInMessageView(snackbarView, completion: completion)
        } else {
            completion()
        }
    }

    func dismissSnackbarView(animated: Bool, completion: @escaping (() -> Void)) {
        if let snackbarView = currentSnackbarView, animated {
            slideOutMessageView(snackbarView) { [weak self] in
                self?.currentSnackbarView = nil
                completion()
            }
        } else {
            self.currentSnackbarView = nil
            completion()
        }
    }

    func setAlignment(_ alignment: SnackbarAlignment) {
        guard self.alignment != alignment else { return }
        self.alignment = alignment
        switch alignment {
        case .center:
            snackbarViewAlignmentLeadingConstraint?.isActive = false
            snackbarViewAlignmentCenterConstarint?.isActive = true
        case .leading:
            snackbarViewAlignmentCenterConstarint?.isActive = false
            snackbarViewAlignmentLeadingConstraint?.isActive = true
        }
    }

    func setLeadingMargin(_ leadingMargin: CGFloat) {
        guard self.leadingMargin != leadingMargin else { return }
        self.leadingMargin = leadingMargin
        snackbarViewLeadingConstraint?.constant = leadingMargin
    }

    func setTrailingMargin(_ trailingMargin: CGFloat) {
        guard self.leadingMargin != leadingMargin else { return }
        self.trailingMargin = trailingMargin
        snackbarViewTrailingConstraint?.constant = -trailingMargin
    }

    func setBottomOffset(_ bottomOffset: CGFloat) {
        guard self.bottomOffset != bottomOffset else { return }
        self.bottomOffset = bottomOffset
        snackbarViewBottomConstraint?.constant = -bottomOffset
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let snackbarView = currentSnackbarView else { return false }
        let snackbarPoint = convert(point, to: snackbarView)
        return snackbarView.point(inside: snackbarPoint, with: event)
    }
}

private extension SnackbarOverlayView {
    func addSnackbarView(_ snackbarView: SnackbarMessageView) {
        currentSnackbarView = snackbarView

        addSubview(snackbarView)
        snackbarView.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            snackbarViewAlignmentCenterConstarint = snackbarView.centerXAnchor.constraint(equalTo: centerXAnchor)
            snackbarViewAlignmentCenterConstarint?.isActive = true

            snackbarViewAlignmentLeadingConstraint = snackbarView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                                                           constant: leadingMargin)
            snackbarViewAlignmentLeadingConstraint?.isActive = (alignment == .leading)

            let minimumWidth: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 288 : 320
            snackbarView.addConstraint(snackbarView.widthAnchor.constraint(greaterThanOrEqualToConstant: minimumWidth))

            let maximumWidth: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 568 : 320
            snackbarView.addConstraint(snackbarView.widthAnchor.constraint(lessThanOrEqualToConstant: maximumWidth))
        } else {
            snackbarViewLeadingConstraint = snackbarView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                                                  constant: leadingMargin)
            snackbarViewLeadingConstraint?.isActive = true

            snackbarViewTrailingConstraint = snackbarView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                                                    constant: -trailingMargin)
            snackbarViewTrailingConstraint?.isActive = true
        }

        snackbarViewBottomConstraint = snackbarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -bottomOffset)
        snackbarViewBottomConstraint?.isActive = true
    }

    func slideInMessageView(_ snackbarView: SnackbarMessageView, completion: @escaping (() -> Void)) {
        snackbarView.alpha = 0
        snackbarView.transform = .init(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            snackbarView.alpha = 1
            snackbarView.transform = .identity
        }, completion: { _ in
            completion()
        })
    }

    func slideOutMessageView(_ snackbarView: SnackbarMessageView, completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.125, delay: 0, options: .curveEaseInOut, animations: {
            snackbarView.alpha = 0
        }, completion: { _ in
            completion()
        })
    }
}
