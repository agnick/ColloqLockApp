import SwiftUI

@MainActor
protocol ColloquiumJoinViewModel: ObservableObject {
    var code: String { get set }
    
    func joinColloquium()
}

struct ColloquiumJoinView<ViewModel: ColloquiumJoinViewModel>: View {
    
    // MARK: - Internal Properties
    
    @StateObject var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    codeFields
                        .onTapGesture {
                            isTextFieldFocused = true
                        }
                    
                    Text(ColloquiumJoinStrings.enterCode)
                        .font(.system(size: 14))
                        .foregroundColor(Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 250)
                    
                    joinButton
                }
                .padding(.bottom, 15)
                
                Spacer()
            }
            .background {
                TextField("", text: $viewModel.code)
                    .focused($isTextFieldFocused)
                    .keyboardType(.numberPad)
                    .opacity(0)
                    .frame(width: 0, height: 0)
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
    // MARK: - Private Properties
    
    @FocusState private var isTextFieldFocused: Bool
    
    // MARK: - Private Views
    
    private var codeFields: some View {
        HStack(spacing: 12) {
            CodeDigitView(text: viewModel.code.count > 0 ? String(viewModel.code[viewModel.code.startIndex]) : "", isFocused: viewModel.code.count == 0 && isTextFieldFocused)
            CodeDigitView(text: viewModel.code.count > 1 ? String(viewModel.code[viewModel.code.index(viewModel.code.startIndex, offsetBy: 1)]) : "", isFocused: viewModel.code.count == 1 && isTextFieldFocused)
            CodeDigitView(text: viewModel.code.count > 2 ? String(viewModel.code[viewModel.code.index(viewModel.code.startIndex, offsetBy: 2)]) : "", isFocused: viewModel.code.count == 2 && isTextFieldFocused)
            CodeDigitView(text: viewModel.code.count > 3 ? String(viewModel.code[viewModel.code.index(viewModel.code.startIndex, offsetBy: 3)]) : "", isFocused: viewModel.code.count == 3 && isTextFieldFocused)
        }
        .frame(width: Layout.mainTextFieldWidth)
    }
    
    private var joinButton: some View {
        MainActionButtonView(
            model: MainActionButtonView.Model(
                text: ColloquiumJoinStrings.joinButton,
                textAlignment: .center,
                action: viewModel.joinColloquium
            )
        )
        .frame(width: Layout.mainActionButtonWidth,
               height: Layout.mainActionButtonHeight)
    }
    
    // MARK: - Private Types
    
    private struct CodeDigitView: View {
        let text: String
        let isFocused: Bool
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? Color.orange : Color.gray, lineWidth: 2)
                
                Text(text)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 70, height: 55)
        }
    }
    
    private enum Layout {
        static var mainTextFieldWidth: CGFloat { 220.0 }
        static var mainTextFieldHeight: CGFloat { 46.0 }
        static var mainActionButtonWidth: CGFloat { 300.0 }
        static var mainActionButtonHeight: CGFloat { 46.0 }
    }
}
