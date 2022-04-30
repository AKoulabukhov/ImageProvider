import UIKit
import MVVMHelpers

public protocol UIImageProviderProtocol: AnyObject {
    var image: Observable<UIImage?> { get }
    var transition: UIImageViewTransitionProtocol { get }
    func onAttach()
    func onDetach()
}

extension UIImageProviderProtocol {
    public var transition: UIImageViewTransitionProtocol {
        UIImageViewInstantImageTransition.default
    }
    public func onAttach() { }
    public func onDetach() { }
}
