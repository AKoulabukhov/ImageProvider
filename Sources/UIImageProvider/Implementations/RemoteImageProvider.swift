import UIKit
import Combine

public protocol RemoteImageLoaderProtocol: AnyObject {
    func loadImage(
        with url: URL,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) -> AnyCancellable?
}

public final class RemoteImageProvider: UIImageProviderProtocol {
    private let url: URL
    private let placeholderImageFactory: StaticUIImageFactoryProtocol?
    private let imageLoader: RemoteImageLoaderProtocol

    private var state: State = .empty
    private var attachCounter = 0 // If used for multiple image views
    private let imageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    private lazy var placeholder: UIImage? = placeholderImageFactory?.makeImage()
    private var cancellationToken: AnyCancellable?

    public init(
        url: URL,
        placeholderImageFactory: StaticUIImageFactoryProtocol? = nil,
        imageLoader: RemoteImageLoaderProtocol
    ) {
        self.url = url
        self.placeholderImageFactory = placeholderImageFactory
        self.imageLoader = imageLoader
    }

    deinit {
        cancellationToken?.cancel()
    }

    // MARK: - UIImageProviderProtocol
    
    public var image: AnyPublisher<UIImage?, Never> { imageSubject.eraseToAnyPublisher() }
    public private(set) var transition: UIImageViewTransitionProtocol = UIImageViewInstantImageTransition.default

    public func onAttach() {
        attachCounter += 1
        guard attachCounter == 1 else { return }
        switch state {
        case .empty, .placeholder:
            loadImage()
        case .loaded:
            return
        }
    }

    public func onDetach() {
        attachCounter -= 1
        guard attachCounter == 0 else { return }
        cancellationToken?.cancel()
    }

    // MARK: - Private

    private func loadImage() {
        cancellationToken = imageLoader.loadImage(
            with: url,
            completion: { [weak self] result in
                runOnMainThread {
                    self?.setLoaderResult(result)
                }
            }
        )
        setPlaceholderIfNeeded()
    }

    private func setLoaderResult(_ result: Result<UIImage, Error>) {
        cancellationToken = nil
        switch result {
        case .success(let loadedImage):
            setImageWithState(
                newImage: loadedImage,
                newState: .loaded
            )
        case .failure:
            setPlaceholderIfNeeded()
        }
    }

    private func setPlaceholderIfNeeded() {
        guard state == .empty else { return }
        setImageWithState(
            newImage: placeholder,
            newState: .placeholder
        )
    }

    private func setImageWithState(
        newImage: UIImage?,
        newState: State
    ) {
        imageSubject.value = newImage
        state = newState
    }
}

extension RemoteImageProvider {
    enum State {
        case empty, placeholder, loaded
    }
}

private func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}
