import SwiftUI

struct LoadingView<ViewModel: LoadingViewModel>: View {
    
    // MARK: - Internal Properties
    
    @StateObject var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                GearLoadingView()
                    .frame(height: 120)
                
                Text(LoadingStrings.waitingForTeacher)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
        }
    }
}

// MARK: - Gear Animation View

private struct GearLoadingView: View {
    @State private var isRotating = false
    
    var body: some View {
        ZStack {
            Image(systemName: "gear")
                .font(.system(size: 80))
                .foregroundColor(.orange)
                .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 2.0)
                        .repeatForever(autoreverses: false),
                    value: isRotating
                )
            
            Image(systemName: "gear")
                .font(.system(size: 40))
                .foregroundColor(.orange.opacity(0.8))
                .offset(x: 50, y: 30)
                .rotationEffect(Angle(degrees: isRotating ? -360 : 0))
                .animation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: isRotating
                )
        }
        .onAppear {
            isRotating = true
        }
    }
}
