import UIKit
import Combine
@testable import UIImageProvider

final class MockUIImageProvider: UIImageProviderProtocol {
    var image: AnyPublisher<UIImage?, Never> { imageSubject.eraseToAnyPublisher() }
    var transition: UIImageViewTransitionProtocol { _transition }

    private let imageSubject = CurrentValueSubject<UIImage?, Never>(nil)

    var _image: UIImage? {
        get { imageSubject.value }
        set { imageSubject.value = newValue }
    }

    var _transition = MockUIImageViewTransition()

    private(set) var onAttachCallsCount = 0
    func onAttach() {
        onAttachCallsCount += 1
    }

    private(set) var onDetachCallsCount = 0
    func onDetach() {
        onDetachCallsCount += 1
    }

}
