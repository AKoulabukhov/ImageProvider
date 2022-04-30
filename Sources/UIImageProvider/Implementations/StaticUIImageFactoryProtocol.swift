import UIKit

public protocol StaticUIImageFactoryProtocol {
    func makeImage() -> UIImage?
}

public struct StaticUIImageBlockFactory: StaticUIImageFactoryProtocol {
    private let block: () -> UIImage?
    public init(block: @escaping () -> UIImage?) {
        self.block = block
    }
    public func makeImage() -> UIImage? {
        block()
    }
}

extension StaticUIImageBlockFactory {
    init(image: UIImage?) {
        self.init(block: { image })
    }

    init(
        imageName: String,
        bundle: Bundle? = nil,
        traitCollection: UITraitCollection? = nil
    ) {
        self.init(
            block: {
                UIImage(
                    named: imageName,
                    in: bundle,
                    compatibleWith: traitCollection
                )
            }
        )
    }
}
