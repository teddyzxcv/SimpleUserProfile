//
//  ContentView.swift
//  UserProfile
//
//  Created by ZhengWu Pan on 26.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = UserModel()
    
    // Make form section with avatar and user details
    var body: some View {
        Form {
            Section{
                HStack{
                    ChangableAvatarView(viewModel: viewModel)
                    VStack{
                        TextField("First Name",
                                  text: $viewModel.firstName,
                                  prompt: Text("First Name")).frame(alignment: .center)
                        TextField("Last Name",
                                  text: $viewModel.lastName,
                                  prompt: Text("Last Name")).frame(alignment: .center)
                        TextField("Last Name",
                                  text: $viewModel.surName,
                                  prompt: Text("Surname")).frame(alignment: .center)
                    }.padding(.leading, 30)
                }
            }
            Section{
                TextField("Email",text: $viewModel.email, prompt: Text("Email")).frame(alignment: .center)
                TextField("TG", text: $viewModel.tg, prompt: Text("TG")).frame(alignment: .center)
                TextField("Telephone",text: $viewModel.tel,prompt: Text("Telephone"))
            }
            Section {
                Button(action: {
                    viewModel.saveInUserDefault()
                }) {
                    Text("Save")
                }
                Button(action: {
                    restore(viewModel: viewModel)
                }) {
                    Text("Cancel")
                }
            }
            
        }
        .padding()
        .onAppear {
            restore(viewModel: viewModel)
        }
    }
}

// Restore all information (image and details)
@MainActor func restore(viewModel: UserModel) {
    let data = UserDefaults.standard.data(forKey: "Avatar") ??
    UIImage(named: "Warning")!.jpegData(compressionQuality: 1)!
    let image = UIImage(data: data)!
    viewModel.setImageStateSuccess(image: Image(uiImage: image))
    for key in viewModel.keyValues {
        switch key {
        case "FirstName":
            viewModel.firstName = UserDefaults.standard.string(forKey: key) ?? ""
        case "LastName":
            viewModel.lastName = UserDefaults.standard.string(forKey: key) ?? ""
        case "Surname":
            viewModel.surName = UserDefaults.standard.string(forKey: key) ?? ""
        case "Email":
            viewModel.email = UserDefaults.standard.string(forKey: key) ?? ""
        case "TG":
            viewModel.tg = UserDefaults.standard.string(forKey: key) ?? ""
        case "Tel":
            viewModel.tel = UserDefaults.standard.string(forKey: key) ?? ""
        case "Nickname":
            viewModel.nickname = UserDefaults.standard.string(forKey: key) ?? ""
        default:
            print("Unknown value")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
