import SwiftUI

@MainActor
final class ToastService: ObservableObject {
    
    // MARK: - Singleton
    static let shared = ToastService()
    
    // MARK: - Published Properties
    @Published private(set) var currentToast: Toast?
    
    // MARK: - Private Properties
    private var dismissTask: Task<Void, Never>?
    
    // MARK: - Public Methods
    static func showError(_ message: String, duration: TimeInterval = 3.0) {
        shared.show(message: message, type: .error, duration: duration)
    }
    
    static func showSuccess(_ message: String, duration: TimeInterval = 3.0) {
        shared.show(message: message, type: .success, duration: duration)
    }
    
    // MARK: - Private Methods
    private func show(message: String, type: ToastType, duration: TimeInterval) {
        dismissTask?.cancel()
        
        currentToast = Toast(message: message, type: type)
        
        dismissTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            await MainActor.run {
                withAnimation(.spring()) {
                    self.currentToast = nil
                }
            }
        }
    }
}

// MARK: - Toast Model
struct Toast: Equatable {
    let id = UUID()
    let message: String
    let type: ToastType
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.id == rhs.id
    }
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
