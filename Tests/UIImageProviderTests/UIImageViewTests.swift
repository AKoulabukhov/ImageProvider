import XCTest
@testable import UIImageProvider

final class UIImageViewTests: XCTestCase {
    private var imageView: UIImageView!

    override func setUp() {
        super.setUp()
        imageView = .init()
    }

    func testThatImageProviderRetainedByImageViewAndNotLeaked() throws {
        var imageProvider: UIImageProviderProtocol? = StaticUIImageProvider(image: nil)
        weak var weakImageProvider = imageProvider

        imageView.imageProvider = imageProvider

        imageProvider = nil
        XCTAssertNotNil(weakImageProvider)

        imageView = nil
        XCTAssertNil(weakImageProvider)
    }

    func testThat_WhenImageProviderSet_ThenTransitionCalled() {
        let image = UIImage()
        let imageProvider = MockUIImageProvider()
        imageProvider._image = image

        imageView.imageProvider = imageProvider

        XCTAssertEqual(imageProvider._transition.setImageCalls.count, 1)
        XCTAssertEqual(imageProvider._transition.setImageCalls[0].image, image)
        XCTAssertEqual(imageProvider._transition.setImageCalls[0].imageView, imageView)
    }

    func testThat_WhenImageProviderSet_ThenOnAttachCalled() {
        let imageProvider = MockUIImageProvider()

        imageView.imageProvider = imageProvider

        XCTAssertEqual(imageProvider.onAttachCallsCount, 1)
    }

    func testThat_WhenImageProviderChanged_ThenOnDetachCalled() {
        let imageProvider1 = MockUIImageProvider()
        let imageProvider2 = MockUIImageProvider()

        imageView.imageProvider = imageProvider1
        imageView.imageProvider = imageProvider2

        XCTAssertEqual(imageProvider1.onDetachCallsCount, 1)
    }
}
