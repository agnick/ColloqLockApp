import SwiftUI
import UIKit

@MainActor
protocol ColloqViewModel: ObservableObject {
    var currentIndex: Int { get }
    var questions: [ColloqQuestionModel] { get }
    var currentQuestion: String { get }
    var currentType: ColloqQuestionType { get }
    var answers: [ColloqAnswerModel] { get set }
    var isLoading: Bool { get }
    var remainingTime: TimeInterval { get }
    
    func onAppear()
    func onDismiss()
    func goNext()
    func goBack()
    func goToIndex(index: Int)
    func markAnswered()
    func markUnanswered()
}

struct ColloqView<ViewModel: ColloqViewModel>: View {
    
    // MARK: - Internal Types
    
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            
            LinearGradient.appBackground
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(Colors.accent)
            } else {
                VStack {
                    header
                    progressBar
                    questionView(for: viewModel.currentQuestion, type: viewModel.currentType)
                    footer
                }
            }
        }
        .onAppear {
            Task {
                viewModel.onAppear()
                print(viewModel.questions.count, viewModel.answers.count)
            }
        }
    }
    
    // MARK: - Private Views
    
    private var header: some View {
        HStack {
            Button(action: {
                viewModel.onDismiss()
            }) {
                Images.SystemImages.chevronLeft
                    .foregroundStyle(Colors.buttonStroke)
            }
            .frame(width: 46, height: 46)
            .background(Colors.buttonPrimary.opacity(0.28))
            .cornerRadius(100)
            .overlay {
                RoundedRectangle(cornerRadius: 100).stroke(Colors.buttonStroke, lineWidth: 1)
            }
            .padding(.leading, 30)
            
            Spacer()
            
            timer
                .padding(.trailing, 20)
        }
    }
    
    private var progressBar: some View {
        VStack(alignment: .center) {
            Text("\(viewModel.currentIndex + 1)/\(viewModel.questions.count)")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Colors.buttonStroke)
            TwoRowProgressBar(questions: viewModel.questions, currentIndex: viewModel.currentIndex, goToIndex: viewModel.goToIndex)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private var footer: some View {
        HStack {
            Button(action: {
                viewModel.goBack()
            }) {
                Images.SystemImages.arrowLeft
                    .foregroundStyle(Colors.buttonStroke)
            }
            .frame(width: 46, height: 46)
            .background(Colors.buttonPrimary.opacity(0.28))
            .cornerRadius(100)
            .overlay {
                RoundedRectangle(cornerRadius: 100).stroke(Colors.buttonStroke, lineWidth: 1)
            }
            .padding(.leading, 30)
            
            Spacer()
            
            Button(action: {
                viewModel.goNext()
            }) {
                Images.SystemImages.arrowRight
                    .foregroundStyle(Colors.buttonStroke)
            }
            .frame(width: 46, height: 46)
            .background(Colors.buttonPrimary.opacity(0.28))
            .cornerRadius(100)
            .overlay {
                RoundedRectangle(cornerRadius: 100).stroke(Colors.buttonStroke, lineWidth: 1)
            }
            .padding(.trailing, 30)
        }
    }
    
    private var timer: some View {
        HStack {
            Spacer()
            Images.SystemImages.hourglass
                .resizable()
                .frame(width: 14, height: 22)
                .foregroundColor(Colors.buttonStroke)
                .padding(.trailing, 1)
            Text(formatTime(viewModel.remainingTime))
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Colors.buttonStroke)
                .padding(.leading, 1)
            Spacer()
        }
        .frame(width: 100, height: 46)
        .background(
            RoundedRectangle(cornerRadius: 250)
                .fill(Colors.backgroundPrimary.opacity(0.3))
                .stroke(Colors.buttonStroke, lineWidth: 1)
                .frame(width: 100, height: 46)
        )
        
    }
    
    private struct TwoRowProgressBar: View {
        let columns: Int = 20
        let rows: Int = 2
        let questions: [ColloqQuestionModel]
        let currentIndex: Int
        let goToIndex: (Int) -> Void
        
        var spacing: CGFloat = 2
        var minItemWidth: CGFloat = 8
        var itemHeight: CGFloat = 4
        var cornerRadius: CGFloat = 4
        
        var body: some View {
            GeometryReader { geo in
                let totalWidth = geo.size.width * 0.9
                let rowSpacingTotal = spacing * CGFloat(columns - 1)
                let availablePerRow = max(totalWidth - rowSpacingTotal, 0)
                let itemWidth = max(minItemWidth, availablePerRow / CGFloat(columns))
                let rowHeight = itemHeight
                let totalHeight = (rowHeight * CGFloat(rows)) + 6 * CGFloat(rows - 1)
                
                VStack(spacing: 20) {
                    ForEach(0..<rows, id: \.self) { row in
                        ProgressRow(
                            row: row,
                            columns: columns,
                            states: questions.map { $0.isAnswered },
                            itemWidth: itemWidth,
                            itemHeight: itemHeight,
                            spacing: spacing,
                            cornerRadius: cornerRadius,
                            currentIndex: currentIndex,
                            goToIndex: goToIndex
                        )
                    }
                }
                .frame(width: totalWidth, height: totalHeight, alignment: .center)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            .frame(height: (itemHeight * CGFloat(rows)) + 6 * CGFloat(rows - 1))
        }
    }
    
    private struct ProgressRow: View {
        let row: Int
        let columns: Int
        let states: [Bool]
        let itemWidth: CGFloat
        let itemHeight: CGFloat
        let spacing: CGFloat
        let cornerRadius: CGFloat
        let currentIndex: Int
        let goToIndex: (Int) -> Void
        
        var body: some View {
            HStack(spacing: spacing) {
                ForEach(0..<columns, id: \.self) { col in
                    let index = row * columns + col
                    cellView(for: states[index], index: index, currentIndex: currentIndex)
                        .frame(width: itemWidth, height: itemHeight)
                }
            }
        }
        
        private func cellView(for state: Bool, index: Int, currentIndex: Int) -> some View {
            var color: Color = Color.white
            
            if index == currentIndex {
                color = Colors.textPrimary
            } else {
                if state {
                    color = Colors.accent
                } else {
                    color = Colors.buttonStroke
                }
            }
            
            return Button(action: {
                goToIndex(index)
            }) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
            }
        }
    }
    
    private struct OpenQuestionView: View {
        @Binding var answer: String
        let question: String
        
        var body: some View {
            VStack {
                Text(question)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                
                Spacer()
                
                ScrollView {
                    VStack {
                        TextEditor(text: $answer)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .font(.system(size: 17))
                            .foregroundStyle(Colors.textPrimary)
                            .padding()
                            .scrollContentBackground(.hidden)
                            .cornerRadius(12)
                            .frame(minHeight: 400)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Colors.buttonStroke, lineWidth: 2)
                                    .foregroundStyle(Colors.buttonStroke)
                            }
                            .id("TextEditor")
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    
    private struct Pick2QuestionView: View {
        @Binding var selected: Int?
        let question: String
        let options: [String]
        
        var body: some View {
            VStack {
                Text(question)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .restrictCapture()
                    .frame(maxHeight: 100)
                
                Spacer()
                
                ForEach(options.indices, id: \.self) { idx in
                    Button {
                        selected = idx
                    } label: {
                        Text(options[idx])
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(selected == idx ? Colors.accent : Colors.buttonStroke, lineWidth: 2)
                            )
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private struct Pick4QuestionView: View {
        @Binding var selected: Set<Int>
        let question: String
        let options: [String]
        
        private let spacing: CGFloat = 12
        
        var body: some View {
            VStack {
                Text(question)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .restrictCapture()
                    .frame(maxHeight: 100)
                
                Spacer()
                
                GeometryReader { geo in
                    let totalSpacing = spacing * 3
                    let itemWidth = (geo.size.width - totalSpacing) / 2
                    
                    LazyVGrid(
                        columns: [GridItem(.fixed(itemWidth)), GridItem(.fixed(itemWidth))],
                        spacing: spacing
                    ) {
                        ForEach(options.indices, id: \.self) { idx in
                            Button {
                                if selected.contains(idx) {
                                    selected.remove(idx)
                                } else {
                                    selected.insert(idx)
                                }
                            } label: {
                                Text(options[idx])
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding()
                                    .frame(maxHeight: .infinity)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selected.contains(idx) ? Colors.accent : Colors.buttonStroke, lineWidth: 2)
                                    )
                            }
                        }
                    }
                }
                .frame(height: 300)
                Spacer()
            }
            .padding(.vertical)
        }
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @ViewBuilder
    private func questionView(for text: String, type: ColloqQuestionType) -> some View {
        switch type {
        case .open:
            OpenQuestionView(
                answer: Binding(
                    get: {
                        if case let .open(value) = viewModel.answers[viewModel.currentIndex] { return value }
                        return ""
                    },
                    set: { newValue in
                        viewModel.answers[viewModel.currentIndex] = .open(newValue)
                        if newValue.isEmpty {
                            viewModel.markUnanswered()
                        } else {
                            viewModel.markAnswered()
                        }
                    }
                ),
                question: text
            )
            .restrictCapture()
        case .pick2:
            let binding = Binding<Int?>(
                get: {
                    if case let .pick2(value) = viewModel.answers[viewModel.currentIndex] { return value }
                    return nil
                },
                set: { newValue in
                    viewModel.answers[viewModel.currentIndex] = .pick2(newValue)
                    viewModel.markAnswered()
                }
            )
            Pick2QuestionView(
                selected: binding,
                question: text,
                options: viewModel.questions[viewModel.currentIndex].options ?? []
            )
        case .pick4:
            let binding = Binding<Set<Int>>(
                get: {
                    if case let .pick4(value) = viewModel.answers[viewModel.currentIndex] { return value }
                    return Set<Int>()
                },
                set: { newValue in
                    viewModel.answers[viewModel.currentIndex] = .pick4(newValue)
                    if newValue.isEmpty {
                        viewModel.markUnanswered()
                    } else {
                        viewModel.markAnswered()
                    }
                }
            )
            Pick4QuestionView(
                selected: binding,
                question: text,
                options: viewModel.questions[viewModel.currentIndex].options ?? []
            )
        }
        
    }
    
    // MARK: - Constants
    
    fileprivate enum Constants {
        // sizes
        
        // paddings
        
        // fonts
        
        // other properties
        
    }
    
}

