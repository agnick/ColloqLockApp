import SwiftUI

struct MainActionButtonView: View {
    
    // MARK: - Internal Types
    
    struct Model {
        let text: String?
        let textAlignment: Alignment
        let image: Image?
        let action: () -> Void
        
        init(
            text: String? = nil,
            textAlignment: Alignment = .leading,
            image: Image? = nil,
            action: @escaping () -> Void
        ) {
            self.text = text
            self.textAlignment = textAlignment
            self.image = image
            self.action = action
        }
    }
    
    // MARK: - Internal Properties
    
    let model: Model
    
    // MARK: - Body
    
    var body: some View {
        Button(action: model.action) {
            HStack(spacing: 8.0) {
                if let image = model.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22.0, height: 22.0)
                }
                
                if let text = model.text {
                    Text(text)
                        .foregroundStyle(Colors.textPrimary)
                        .font(.system(size: 15, weight: .semibold))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: model.textAlignment)
                }
            }
        }
        .padding()
        .background(Colors.buttonPrimary)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Colors.buttonStroke, lineWidth: 2.0)
        )
    }
}
