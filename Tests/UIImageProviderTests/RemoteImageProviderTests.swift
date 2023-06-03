import XCTest
import Combine
@testable import UIImageProvider

final class RemoteImageProviderTests: XCTestCase {
    private let url = URL(fileURLWithPath: "/dev/null")
    private let placeholder = UIImage()
    private var placeholderFactoryCallsCount: Int!
    private var imageLoader: MockRemoteImageLoader!
    private var sut: RemoteImageProvider!

    override func setUp() {
        placeholderFactoryCallsCount = 0
        imageLoader = MockRemoteImageLoader()
        sut = RemoteImageProvider(
            url: url,
            placeholderImageFactory: StaticUIImageBlockFactory(
                block: {
                    self.placeholderFactoryCallsCount += 1
                    return self.placeholder
                }
            ),
            imageLoader: imageLoader
        )
        super.setUp()
    }

    override func tearDown() {
        imageLoader = nil
        sut = nil
        super.tearDown()
    }

    func testThat_WhenSutCreated_ThenNoImageSetAndTransitionAssigned() {
        XCTAssertNil(sut.consume())
        XCTAssertTrue(sut.transition === UIImageViewInstantImageTransition.default)
    }

    func testThat_WhenAttached_ThenImageLoadingStartedAndPlaceholderSet() {
        sut.onAttach()

        XCTAssertEqual(imageLoader.loadImageCalls.count, 1)
        XCTAssertEqual(imageLoader.loadImageCalls[0].url, url)
        XCTAssertEqual(sut.consume(), placeholder)
    }

    func testThat_WhenLoadingCompleted_ThenImageSet() {
        let loadedImage = UIImage()

        sut.onAttach()
        imageLoader.loadImageCalls[0].completion(.success(loadedImage))

        XCTAssertEqual(sut.consume(), loadedImage)
    }

    func testThat_WhenLoadingFails_ThenPlaceholderSet() {
        sut.onAttach()
        imageLoader.loadImageCalls[0].completion(.failure(NSError.networkError))

        XCTAssertEqual(sut.consume(), placeholder)
    }

    func testThat_WhenLoaderCompletesImmediately_ThenImageSetAndPlaceholderNotCreated() {
        let loadedImage = UIImage()
        imageLoader.loadImageInstantCompletionResult = .success(loadedImage)

        sut.onAttach()

        XCTAssertEqual(placeholderFactoryCallsCount, 0)
        XCTAssertEqual(sut.consume(), loadedImage)
    }

    func testThat_WhenLoaderFailsImmediately_ThenPlaceholderSet() {
        imageLoader.loadImageInstantCompletionResult = .failure(NSError.networkError)

        sut.onAttach()

        XCTAssertEqual(sut.consume(), placeholder)
    }

    func testThat_GivenImageLoading_WhenDetachCalled_ThenImageLoaderCancelled() {
        var cancelCallsCount = 0
        imageLoader.loadImageReturnValue = AnyCancellable { cancelCallsCount += 1 }
        sut.onAttach()

        sut.onDetach()

        XCTAssertEqual(cancelCallsCount, 1)
    }

    func testThat_GivenImageLoaded_WhenDetachCalled_ThenImageLoaderNotCancelled() {
        var cancelCallsCount = 0
        imageLoader.loadImageReturnValue = AnyCancellable { cancelCallsCount += 1 }
        sut.onAttach()
        imageLoader.loadImageCalls[0].completion(.success(UIImage()))

        sut.onDetach()

        XCTAssertEqual(cancelCallsCount, 0)
    }

    func testThat_GivenFirstLoadCancelled_WhenAttachedAgain_ThenLoadCalledAgain() {
        sut.onAttach()
        sut.onDetach()
        sut.onAttach()

        XCTAssertEqual(imageLoader.loadImageCalls.count, 2)
    }

    func testThat_GivenImageLoaded_WhenAttached_ThenLoadNotCalledAgain() {
        sut.onAttach()
        imageLoader.loadImageCalls[0].completion(.success(UIImage()))

        sut.onDetach()
        sut.onAttach()
        XCTAssertEqual(imageLoader.loadImageCalls.count, 1)
    }

    func testThat_WhenAttachedToMultipleInstances_ThenLoadCalledOnce() {
        sut.onAttach()
        sut.onAttach()

        XCTAssertEqual(imageLoader.loadImageCalls.count, 1)
    }

    func testThat_WhenDetachedFromOneOfMultipleInstancesThenNotCancelled() {
        var cancelCallsCount = 0
        imageLoader.loadImageReturnValue = AnyCancellable { cancelCallsCount += 1 }
        sut.onAttach()
        sut.onAttach()

        sut.onDetach()

        XCTAssertEqual(cancelCallsCount, 0)
    }
}

private extension NSError {
    static var networkError: NSError {
        NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorNetworkConnectionLost,
            userInfo: nil
        )
    }
}
