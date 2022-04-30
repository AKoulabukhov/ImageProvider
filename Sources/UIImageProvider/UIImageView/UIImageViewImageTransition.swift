import UIKit

public protocol UIImageViewTransitionProtocol: AnyObject {
    func setImage(
        _ image: UIImage?,
        on imageView: UIImageView
    )
}

public final class UIImageViewInstantImageTransition: UIImageViewTransitionProtocol {
    public static let `default` = UIImageViewInstantImageTransition()

    public init() { }

    public func setImage(
        _ image: UIImage?,
        on imageView: UIImageView
    ) {
        imageView.image = image
    }
}

public final class UIImageViewAnimatedImageTransition: UIImageViewTransitionProtocol {
    public static let `default` = UIImageViewAnimatedImageTransition()

    private let animationDuration: TimeInterval
    private let options: UIView.AnimationOptions

    public init(
        animationDuration: TimeInterval = CATransaction.animationDuration(),
        options: UIView.AnimationOptions = [.transitionCrossDissolve]
    ) {
        self.animationDuration = animationDuration
        self.options = options
    }

    public func setImage(
        _ image: UIImage?,
        on imageView: UIImageView
    ) {
        UIView.transition(
            with: imageView,
            duration: animationDuration,
            options: options,
            animations: {
                imageView.image = image
            },
            completion: nil
        )
    }
}
