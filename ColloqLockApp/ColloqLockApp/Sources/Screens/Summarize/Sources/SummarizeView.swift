import SwiftUI

@MainActor
protocol SummarizeViewModel: ObservableObject {
    var testQuestionsTitles: [String] { get }
    var testAnswersTitles: [String] { get }
    var openQuestionsTitles: [String] { get }
    var openAnswersTitles: [String] { get }
}

struct SummarizeView<ViewModel: SummarizeViewModel>: View {
    // MARK: - Internal properties
    @StateObject var viewModel: ViewModel
    
    // MARK: - Body
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    HStack(alignment: .center) {
                        Button(action: {}) {
                            Images.SystemImages.chevronLeft
                                .foregroundStyle(Colors.buttonStroke)
                        }
                        .frame(width: Layout.Button.size, height: Layout.Button.size)
                        .background(Colors.buttonPrimary.opacity(Layout.Button.backButtonOpacity))
                        .cornerRadius(Layout.cornerRadius)
                        .overlay {
                            RoundedRectangle(cornerRadius: Layout.cornerRadius).stroke(Colors.buttonStroke, lineWidth: Layout.strokeLineWidth)
                        }
                        
                        Spacer()
                    }
                    testQuestionsBlock
                    openQuestionsBlock
                }
                .padding(.horizontal, Layout.contentHorizontalPadding)
            }
        }
        .safeAreaInset(edge: .bottom) {
            MainActionButtonView(
                model: MainActionButtonView.Model(
                    text: SummarizeStrings.endColloqButtonText,
                    textAlignment: .center,
                    action: {}
                )
            )
            .frame(width: Layout.Button.endButtonWidth, height: Layout.Button.size)
        }
    }
    
    // MARK: - Private views
    @ViewBuilder
    private var testQuestionsBlock: some View {
        Text(SummarizeStrings.testAnswersTitle)
            .font(.system(size: Layout.titleFontSize))
            .foregroundStyle(Colors.textPrimary)
        
        VStack(alignment: .center, spacing: Layout.TestQuestions.blockItemSpacing) {
            ForEach(Array(viewModel.testQuestionsTitles.enumerated()), id: \.offset) { index, title in
                TestQuestionCardView(
                    question: "\(index + 1). \(title)",
                    givenAnswer: viewModel.testAnswersTitles[index]
                )
            }
        }
        .padding(.top, Layout.blockContentTopPadding)
    }
    
    @ViewBuilder
    private var openQuestionsBlock: some View {
        Text(SummarizeStrings.openAnswersTitle)
            .font(.system(size: Layout.titleFontSize))
            .foregroundStyle(Colors.textPrimary)
            .padding(.top, Layout.blockContentTopPadding)
        
        VStack(alignment: .center, spacing: Layout.OpenQuestions.blockItemSpacing) {
            ForEach(Array(viewModel.openQuestionsTitles.enumerated()), id: \.offset) { index, title in
                OpenQuestionCardView(
                    question: "\(index + 1). \(title)",
                    givenAnswer: viewModel.openAnswersTitles[index]
                )
            }
        }
        .padding(.top, Layout.blockContentTopPadding)
    }

}

// MARK: - Test Flip Card View
private struct TestQuestionCardView: View {
    let question: String
    let givenAnswer: String
    
    @State private var flipped: Bool = false
    @State private var rotation: CGFloat = .zero
    
    var body: some View {
        ZStack {
            // Question side
            HStack(alignment: .center) {
                    Text(question)
                        .font(.system(size: Layout.mediumFontSize))
                        .foregroundStyle(Colors.textPrimary)
                    Spacer()
                Images.SystemImages.chevronRight
                        .foregroundStyle(Colors.textPrimary)
                }
            .opacity(flipped ? 0 : 1)
            
            // Given answer side
            HStack(alignment: .center) {
                Text(givenAnswer)
                    .font(.system(size: Layout.mediumFontSize, weight: .semibold))
                    .foregroundStyle(givenAnswer == "Пропущено" ? .red : Colors.textPrimary)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .opacity(flipped ? 1 : 0)
            .rotation3DEffect(.degrees(Layout.TestQuestions.rotationDegrees), axis: (x: 0, y: 1, z: 0))
        }
        .padding(.horizontal, Layout.TestQuestions.cardContentHorizontalPadding)
        .frame(height: Layout.TestQuestions.cardHeight)
        .background(Colors.buttonPrimary)
        .cornerRadius(Layout.cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(Colors.buttonStroke, lineWidth: Layout.strokeLineWidth)
        }
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.spring(duration: 0.5)) {
                rotation += Layout.TestQuestions.rotationDegrees
                flipped.toggle()
            }
        }
    }
}

// MARK: - Open Type Card
private struct OpenQuestionCardView: View {
    let question: String
    let givenAnswer: String
    
    var body: some View {
        VStack(alignment: .center, spacing: Layout.OpenQuestions.cardContentSpacing) {
            Text(question)
                .font(.system(size: Layout.mediumFontSize))
                .foregroundStyle(Colors.textPrimary)
                .padding(.top, Layout.OpenQuestions.cardContentVerticalPadding)
            
            Divider()
                .background(Colors.textPrimary)
            
            Text(givenAnswer)
                .font(.system(size: Layout.mediumFontSize))
                .foregroundStyle(givenAnswer == "Пропущено" ? .red : Colors.textPrimary)
                .padding(.bottom, Layout.OpenQuestions.cardContentVerticalPadding)
        }
        .padding(.horizontal, Layout.TestQuestions.cardContentHorizontalPadding)
        .background(Colors.buttonPrimary)
        .cornerRadius(Layout.OpenQuestions.cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: Layout.OpenQuestions.cornerRadius)
                .stroke(Colors.buttonStroke, lineWidth: Layout.strokeLineWidth)
        }
    }
}

// MARK: - Layout
private enum Layout {
    static var titleFontSize: CGFloat = 34 
    static var mediumFontSize: CGFloat = 16
    static var cornerRadius: CGFloat = 100
    static var strokeLineWidth: CGFloat = 1
    
    static var contentHorizontalPadding: CGFloat = 32
    
    static var blockContentTopPadding: CGFloat = 16
    
    enum Button {
        static var size: CGFloat = 46
        static var endButtonWidth: CGFloat = 140
        static var backButtonOpacity: CGFloat = 0.28
    }
    
    enum TestQuestions {
        static var cardHeight: CGFloat = 46
        static var cardContentHorizontalPadding: CGFloat = 16
        static var rotationDegrees: CGFloat = 180
        static var blockItemSpacing: CGFloat = 8
    }
    
    enum OpenQuestions {
        static var cornerRadius: CGFloat = 25
        static var cardContentVerticalPadding: CGFloat = 16
        static var cardContentSpacing: CGFloat = 8
        static var blockItemSpacing: CGFloat = 24
    }
}
