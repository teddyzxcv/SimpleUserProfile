import SwiftUI
import PhotosUI

// MARK: Profile image view
struct ProfileImage: View {
    let imageState: UserModel.ImageState
    
    // Every state and it icon.
    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image("Avatar")
                .resizable()
                .scaledToFit()
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image("Warning")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

// Avatar view with circle and changable icon.
struct ChangableAvatarView: View {
    @ObservedObject var viewModel: UserModel
    
    var body: some View {
        ProfileImage(imageState: viewModel.imageState)
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 100, height: 100)
            .background {
                Circle().fill(
                    Color(.red)
                )
            }
            .overlay(alignment: .center) {
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Circle()
                        .opacity(0)
                }
                .buttonStyle(.borderless)
            }
    }
}
