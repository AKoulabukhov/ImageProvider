import UIKit
import Combine

public final class StaticUIImageProvider: UIImageProviderProtocol {
    public var image: AnyPublisher<UIImage?, Never> { imageSubject.eraseToAnyPublisher() }
    public let transition: UIImageViewTransitionProtocol

    private let imageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    private var imageFactory: StaticUIImageFactoryProtocol?

    public init(
        imageFactory: StaticUIImageFactoryProtocol,
        transition: UIImageViewTransitionProtocol = UIImageViewInstantImageTransition.default
    ) {
        self.imageFactory = imageFactory
        self.transition = transition
    }

    public func onAttach() {
        guard let imageFactory = imageFactory else { return }
        imageSubject.value = imageFactory.makeImage()
        self.imageFactory = nil
    }
}

// MARK: - Convenience init

extension StaticUIImageProvider {
    public convenience init(
        image: UIImage?,
        transition: UIImageViewTransitionProtocol = UIImageViewInstantImageTransition.default
    ) {
        self.init(
            imageFactory: StaticUIImageBlockFactory(
                image: image
            ),
            transition: transition
        )
    }

    public convenience init(
        imageName: String,
        bundle: Bundle? = nil,
        traitCollection: UITraitCollection? = nil,
        transition: UIImageViewTransitionProtocol = UIImageViewInstantImageTransition.default
    ) {
        self.init(
            imageFactory: StaticUIImageBlockFactory(
                imageName: imageName,
                bundle: bundle,
                traitCollection: traitCollection
            ),
            transition: transition
        )
    }
}
