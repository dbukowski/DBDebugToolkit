import UIKit

@objc
public extension UIWindow {
    static var keyWindow: UIWindow?  {
        UIApplication.shared.windows.first(where: \.isKeyWindow)
    }
}
