import SwiftUI

@MainActor
protocol ColloqCreationViewModel: ObservableObject {
    
}

struct ColloqCreationView<ViewModel: ColloqCreationViewModel>: View {
    
    // MARK: - Internal Properties
    
    let model: ViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            
        }
    }
}
