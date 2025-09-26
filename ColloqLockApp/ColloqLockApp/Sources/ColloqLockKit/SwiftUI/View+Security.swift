import SwiftUI

extension View {
    
    func restrictCapture() -> some View {
        RestrictCaptureView { self }
    }
}
