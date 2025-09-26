import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModelImpl: ProfileViewModel {
    
    // MARK: - Internal Properties
    
    @Published var username: String = ProfileStrings.username
    @Published var colloqs: [Colloq] = []
    @Published var isLoading: Bool = false
    @Published var isEditing = false
    @Published var isImagePickerPresented = false
    @Published var selectedImage: PhotosPickerItem? = nil
    @Published var userRole: UserRole = .student
    
    // MARK: - Init
    
    init(interactor: ProfileInteractor, router: ProfileRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Public Methods
    
    func onAppear() {
        onAppearTask?.cancel()
        isLoading = true
        
        onAppearTask = Task {
            defer { isLoading = false }
            do {
                guard let userProfile = try await interactor.loadProfile() else {
                    return
                }
                
                username = userProfile.displayName
                userRole = userProfile.role
                
                colloqs = try await interactor.loadColloqs()
            } catch {
                print("Load data error: \(error)")
            }
        }
    }
    
    func onChangeProfile() {
        
    }
    
    func signOut() {
        do {
            try interactor.signOut()
            router.routeTo(.authScreen)
        } catch {
            print(error)
        }
    }
    
    func joinColloq() {
        router.routeTo(.colloqJoin)
    }
    
    // MARK: - Private Properties
    
    private let interactor: ProfileInteractor
    private let router: ProfileRouter
    
    private var onAppearTask: Task<Void, Never>?
}
