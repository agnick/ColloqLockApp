import SwiftUI
import PhotosUI

@MainActor
protocol ProfileViewModel: ObservableObject {
    var username: String { get set }
    var isLoading: Bool { get }
    var isEditing: Bool { get set }
    var selectedImage: PhotosPickerItem? { get set }
    var colloqs: [Colloq] { get }
    var userRole: UserRole { get }
    
    func onAppear()
    func onChangeProfile()
    func signOut()
    func joinColloq()
    func onColloqsRefresh()
}

struct ProfileView<ViewModel: ProfileViewModel>: View {
    
    // MARK: - Internal Types
    
    @StateObject var viewModel: ViewModel
    @State private var avatarImage: UIImage = UIImage() // TODO: avatar вернуть
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(Colors.accent)
            } else {
                VStack {
                    profile
                    
                    if viewModel.userRole == .student {
                        colloqJoin
                    } else {
                        colloqCreate
                    }
                    
                    listLabel
                    colloqList
                }
            }
            
        }
        .onAppear {
            Task {
                viewModel.onAppear()
            }
        }
    }
    
    // MARK: - Private Views
    
    private var profile: some View {
        VStack {
            avatar
            
            HStack(alignment: .center) {
                Spacer()
                
                if viewModel.isEditing {
                    TextField(ProfileStrings.textFieldText, text: $viewModel.username)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: Constants.usernameSize, weight: .bold))
                        .foregroundColor(Colors.accent)
                        .multilineTextAlignment(.center)
                        .fixedSize()
                } else {
                    Text(viewModel.username)
                        .font(.system(size: Constants.usernameSize, weight: .bold))
                        .foregroundStyle(Colors.textPrimary)
                }
                
                Button(action: {
                    withAnimation {
                        if viewModel.isEditing {
                            viewModel.onChangeProfile()
                        }
                        
                        viewModel.isEditing.toggle()
                        if viewModel.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            viewModel.username = ProfileStrings.username
                        }
                    }
                }) {
                    (viewModel.isEditing ? Images.SystemImages.checkmark : Images.SystemImages.pencil)
                        .resizable()
                        .frame(width: Constants.changeSize, height: Constants.changeSize)
                        .foregroundColor(viewModel.isEditing ? Colors.accent : Colors.textPrimary)
                }
                
                Spacer()
            }
            
            Text(ProfileStrings.signOut)
                .foregroundStyle(Colors.textSecondary)
                .fontWeight(.semibold)
                .onTapGesture {
                    viewModel.signOut()
                }
        }
        .padding(.top, Constants.profileTop)
    }
    
    private var avatar: some View {
        Images.LocalImages.avatar
            .resizable()
            .frame(width: Constants.avatarSize, height: Constants.avatarSize)
            .clipShape(Circle())
    }
    
    private var colloqJoin: some View {
        MainActionButtonView(model: MainActionButtonView.Model(
            text: ProfileStrings.joinColloq,
            textAlignment: .leading,
            action: {
                viewModel.joinColloq()
            }
        ))
        .padding(.vertical, 15)
        .padding(.horizontal, 40)
    }
    
    private var colloqCreate: some View {
        Button(
            action: {
    
            },
            label: {
                Text("Создать новый коллоквиум")
            }
        )
        .buttonStyle(.bordered)
    }
    
    private var listLabel: some View {
        HStack {
            Text(ProfileStrings.listLabel)
                .font(.system(size: Constants.listLabelSize, weight: .bold))
                .foregroundStyle(Colors.textPrimary)
            
            Spacer()
        }
        .padding(.leading, Constants.listLabelLeading)
    }
    
    private var colloqList: some View {
        List {
            ForEach(viewModel.colloqs) { colloq in
                createCell(name: colloq.name, date: colloq.date)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: Constants.cellVertical,
                                              leading: Constants.cellHorizontal,
                                              bottom: Constants.cellVertical,
                                              trailing: Constants.cellHorizontal))
            }
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        .refreshable {
            viewModel.onColloqsRefresh()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Private functions
    
    private func createCell(name: String, date: String) -> some View {
        VStack(alignment: .center) {
            HStack {
                Images.LocalImages.colloqItem
                    .resizable()
                    .frame(width: Constants.colloqItemSize, height: Constants.colloqItemSize)
                
                VStack(alignment: .leading) {
                    Text(name)
                        .foregroundColor(Colors.textPrimary)
                        .font(.system(size: Constants.colloqTextSize, weight: .bold))
                    Text(date)
                        .foregroundColor(Colors.textPrimary)
                        .font(.system(size: Constants.colloqDateSize))
                }
                
                Spacer()
            }
        }
        .padding(.leading, Constants.colloqItemLeading)
        .frame(maxWidth: .infinity)
        .frame(height: Constants.cellHeight)
        .background(
            RoundedRectangle(cornerRadius: Constants.cellCornerRadius)
                .stroke(Colors.buttonStroke, lineWidth: Constants.cellStrokeWidth)
        )
    }
    
}

// MARK: - Constants

fileprivate enum Constants {
    // sizes
    static let changeSize = 15.0
    static let avatarSize = 100.0
    static let colloqItemSize = 40.0
    static let cellHeight = 70.0
    
    // paddings
    static let profileTop = 30.0
    static let listLabelTop = 30.0
    static let listLabelLeading = 15.0
    static let colloqListSpacing = 10.0
    static let colloqItemLeading = 15.0
    static let cellHorizontal = 15.0
    static let cellVertical = 10.0
    
    // fonts
    static let usernameSize = 20.0
    static let listLabelSize = 24.0
    static let colloqTextSize = 18.0
    static let colloqDateSize = 16.0
    
    // other properties
    static let photoPickerOpacity = 0.3
    static let cellCornerRadius = 15.0
    static let cellStrokeWidth = 2.0
}
