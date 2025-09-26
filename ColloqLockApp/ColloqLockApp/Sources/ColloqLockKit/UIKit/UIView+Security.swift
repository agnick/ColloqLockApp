import UIKit

extension UIView {
    
    static var secureView: UIView {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        //textField.isUserInteractionEnabled = false
        guard let secureView = textField.layer.sublayers?.first?.delegate as? UIView else {
            return .init()
        }
        
        secureView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        return secureView
    }
    
}
