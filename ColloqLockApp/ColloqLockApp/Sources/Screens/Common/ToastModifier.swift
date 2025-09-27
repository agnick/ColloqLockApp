import SwiftUI

struct ToastModifier: ViewModifier {
    @StateObject private var toastService = ToastService.shared
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if let toast = toastService.currentToast {
                        ToastView(toast: toast)
                            .padding(.top, 10)
                            .transition(.asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),  
                                removal: .opacity
                            ))
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: toastService.currentToast != nil),
                alignment: .top
            )
    }
}

extension View {
    func withToast() -> some View {
        self.modifier(ToastModifier())
    }
}
