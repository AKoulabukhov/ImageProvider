import UIKit
import Combine

public protocol UIImageProviderProtocol: AnyObject {
    var image: AnyPublisher<UIImage?, Never> { get }
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
