import UIKit
import Combine

private var imageProviderKey: UInt8 = 0
private var imageProviderObservationKey: UInt8 = 0

extension UIImageView {

    public var imageProvider: UIImageProviderProtocol? {
        get { value(forKey: &imageProviderKey) }
        set { setImageProvider(newValue) }
    }

    private var imageProviderObservation: AnyCancellable? {
        get { value(forKey: &imageProviderObservationKey) }
        set { setValue(newValue, forKey: &imageProviderObservationKey) }
    }

    private func setImageProvider(_ imageProvider: UIImageProviderProtocol?) {
        guard self.imageProvider !== imageProvider else {
            return
        }

        self.imageProvider?.onDetach()
        setValue(imageProvider, forKey: &imageProviderKey)

        guard let imageProvider = imageProvider else {
            imageProviderObservation = nil
            return
        }

        imageProvider.onAttach()
        imageProviderObservation = imageProvider.image.sink { [weak self, weak imageProvider] image in
            guard
                let self = self,
                let transition = imageProvider?.transition
            else {
                return
            }
            transition.setImage(
                image,
                on: self
            )
        }
    }

    private func value<T>(forKey key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(self, key) as? T
    }

    private func setValue(_ value: Any?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(
            self,
            key,
            value,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}
