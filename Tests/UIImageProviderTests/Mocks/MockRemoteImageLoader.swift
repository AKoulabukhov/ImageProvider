import UIKit
import Combine
@testable import UIImageProvider

final class MockRemoteImageLoader: RemoteImageLoaderProtocol {
    var loadImageCalls = [(url: URL, completion: (Result<UIImage, Error>) -> Void)]()
    var loadImageInstantCompletionResult: Result<UIImage, Error>?
    var loadImageReturnValue: AnyCancellable?

    func loadImage(
        with url: URL,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) -> AnyCancellable? {
        loadImageCalls.append((url, completion))
        if let result = loadImageInstantCompletionResult {
            completion(result)
        }
        return loadImageReturnValue
    }
}
