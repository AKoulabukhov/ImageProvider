import UIKit
import Combine
@testable import UIImageProvider

extension UIImageProviderProtocol {
    func consume() -> UIImage? {
        var result: UIImage?
        _ = image.sink { result = $0 }
        return result
    }
}
