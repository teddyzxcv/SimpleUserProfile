/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An observable state object that contains profile details.
*/

import SwiftUI
import PhotosUI
import UIKit
import CoreTransferable

@MainActor
class UserModel: ObservableObject {
    
    // MARK: - User Details
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var surName: String = ""
    @Published var tel: String = ""
    @Published var tg: String = ""
    @Published var email: String = ""
    @Published var nickname: String = ""

    
    // MARK: - User Image state
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    /// What if transfer image failed
    enum TransferError: Error {
        case importFailed
    }
    
    /// Transferable for image, used for error handling and show loading state.
    struct ProfileImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                UserDefaults.standard.set(data, forKey: "Avatar")
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
            }
        }
    }
    
    // Image state to bind loading, success and error state
    @Published private(set) var imageState: ImageState = .empty
    
    // Set image state for restore data from UserDefault from other view.
    public func setImageStateSuccess(image: Image) {
        self.imageState = .success(image)
    }
    
    // Photo picked item for pick item in PhotoPicker
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    // All key value in UserDefault
    let keyValues = ["FirstName", "LastName", "Surname", "Email", "TG", "Tel", "Nickname"]
    
    // Save all fields
    public func saveInUserDefault() {
        print("Save to user default")
        for key in keyValues {
            switch key {
                case "FirstName":
                    UserDefaults.standard.set(firstName, forKey: key)
                case "LastName":
                    UserDefaults.standard.set(lastName, forKey: key)
                case "Surname":
                    UserDefaults.standard.set(surName, forKey: key)
                case "Email":
                    UserDefaults.standard.set(email, forKey: key)
                case "TG":
                    UserDefaults.standard.set(tg, forKey: key)
                case "Tel":
                    UserDefaults.standard.set(tel, forKey: key)
                case "Nickname":
                    UserDefaults.standard.set(nickname, forKey: key)
                default:
                    print("Unknown value")
                }
        }
    }

    
    // MARK: - Private Methods
    
    // Loading state in image picker, after go to success or failure
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}
