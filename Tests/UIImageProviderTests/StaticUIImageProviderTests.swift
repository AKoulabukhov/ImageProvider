import XCTest
@testable import UIImageProvider

final class StaticUIImageProviderTests: XCTestCase {
    private let transition = UIImageViewAnimatedImageTransition.default
    private var image: UIImage?
    private var imageFactory: StaticUIImageBlockFactory!
    private var imageFactoryCallsCount: Int!
    private var sut: StaticUIImageProvider!

    override func setUp() {
        super.setUp()
        image = UIImage()
        imageFactoryCallsCount = 0
    }

    override func tearDown() {
        imageFactory = nil
        sut = nil
        super.tearDown()
    }

    func testThat_WhenSutCreated_ThenNoImageSetAndTransitionAssigned() {
        sut = makeSut()

        XCTAssertNil(sut.consume())
        XCTAssertTrue(sut.transition === transition)
    }

    func testThat_WhenSutAttached_ThenImageSet() {
        sut = makeSut()

        sut.onAttach()

        XCTAssertEqual(sut.consume(), image)
    }

    func testThat_WhenSutAttachedMultipleTimes_ThenImageCreatedOnce() {
        sut = makeSut()

        sut.onAttach()
        sut.onAttach()

        XCTAssertEqual(imageFactoryCallsCount, 1)
    }

    private func makeSut() -> StaticUIImageProvider {
        imageFactory = StaticUIImageBlockFactory(
            block: {
                self.imageFactoryCallsCount += 1
                return self.image
            }
        )
        return StaticUIImageProvider(
            imageFactory: imageFactory,
            transition: transition
        )
    }
}
