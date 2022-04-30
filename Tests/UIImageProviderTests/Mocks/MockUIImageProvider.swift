import UIKit
import MVVMHelpers
@testable import UIImageProvider

final class MockUIImageProvider: UIImageProviderProtocol {
    private(set) var image: Observable<UIImage?> = Observable(nil)
    var transition: UIImageViewTransitionProtocol { _transition }

    var _image: UIImage? {
        get { image.value }
        set { image.value = newValue }
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
