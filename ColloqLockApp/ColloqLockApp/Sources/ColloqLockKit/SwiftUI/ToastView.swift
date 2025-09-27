import SwiftUI

struct ToastView: View {
    let toast: Toast
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.type.icon)
                .foregroundColor(Colors.textPrimary)
            
            Text(toast.message)
                .foregroundColor(Colors.textPrimary)
                .font(.system(size: 14, weight: .medium))
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Colors.accent)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}
