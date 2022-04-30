import UIKit
@testable import UIImageProvider

final class MockUIImageViewTransition: UIImageViewTransitionProtocol {
    private(set) var setImageCalls: [(image: UIImage?, imageView: UIImageView)] = []

    func setImage(_ image: UIImage?, on imageView: UIImageView) {
        setImageCalls.append((image, imageView))
    }
}
