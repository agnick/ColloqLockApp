import SwiftUI

@MainActor
enum ToastService {
    
    static func showError(_ message: String, duration: TimeInterval = 3.0) {
        show(message: message, type: .error, duration: duration)
    }
    
    static func showSuccess(_ message: String, duration: TimeInterval = 3.0) {
        show(message: message, type: .success, duration: duration)
    }
    
    private static func show(message: String, type: ToastType, duration: TimeInterval = 3.0) {
        if let hosting = currentToast {
            hosting.view.removeFromSuperview()
            currentToast = nil
        }
        
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.keyWindow else {
            return
        }
        
        let toastView = ToastView(toast: Toast(message: message, type: type))
        let hosting = UIHostingController(rootView: toastView)
        hosting.view.backgroundColor = .clear
        
        let height: CGFloat = 80
        hosting.view.frame = CGRect(
            x: 0,
            y: 50,
            width: window.bounds.width,
            height: height
        )
        
        hosting.view.transform = CGAffineTransform(translationX: 0, y: -150)
        hosting.view.alpha = 0.0
        
        window.addSubview(hosting.view)
        currentToast = hosting
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                hosting.view.transform = .identity
                hosting.view.alpha = 1.0
            }
        ) { _ in
            UIView.animate(
                withDuration: 0.3,
                delay: duration,
                options: .curveEaseIn,
                animations: {
                    hosting.view.transform = CGAffineTransform(translationX: 0, y: -150)
                    hosting.view.alpha = 0.0
                }
            ) { _ in
                hosting.view.removeFromSuperview()
                if currentToast === hosting {
                    currentToast = nil
                }
            }
        }
    }
    
    private static var currentToast: UIHostingController<ToastView>?
}

// MARK: - Toast Model

struct Toast: Equatable {
    let id = UUID()
    let message: String
    let type: ToastType
}

enum ToastType {
    case error
    case success
    
    var color: Color {
        switch self {
        case .error: return .red
        case .success: return .green
        }
    }
    
    var icon: String {
        switch self {
        case .error: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }
}
