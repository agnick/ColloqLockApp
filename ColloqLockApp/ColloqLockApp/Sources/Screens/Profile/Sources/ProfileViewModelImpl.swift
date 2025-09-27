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
                let userProfileData = try await interactor.loadProfile()
            
                username = userProfileData.displayName
                userRole = userProfileData.role
                
                colloqs = try await interactor.loadColloqs()
            } catch let error as ProfileError {
                ToastService.showError(error.description)
                print(error)
            } catch {
                ToastService.showError(ProfileError.unknown.description)
                print(error)
            }
        }
    }
    
    func onColloqsRefresh() {
        onColloqsRefreshTask?.cancel()
        
        onColloqsRefreshTask = Task {
            do {
                colloqs = try await interactor.loadColloqs()
            } catch let error as ProfileError {
                ToastService.showError(error.description)
                print(error)
            } catch {
                ToastService.showError(ProfileError.unknown.description)
                print(error)
            }
        }
    }
    
    func onChangeProfile() {
        onChangeProfileTask?.cancel()
        
        if username.isEmpty {
            ToastService.showError(ProfileError.nameIsEmpty.description)
            return
        }
        
        onChangeProfileTask = Task {
            do {
                try await interactor.changeUserProfile(with: username)
            } catch let error as ProfileError {
                ToastService.showError(error.description)
                print(error)
            } catch {
                ToastService.showError(ProfileError.unknown.description)
                print(error)
            }
        }
    }
    
    func signOut() {
        do {
            try interactor.signOut()
        } catch {
            ToastService.showError(ProfileError.unknown.description)
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
    private var onChangeProfileTask: Task<Void, Never>?
    private var onColloqsRefreshTask: Task<Void, Never>?
}
