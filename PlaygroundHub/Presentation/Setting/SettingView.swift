//
//  SettingView.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2022/02/08.
//

import SwiftUI
import Carte

struct SettingView: View {
    @ObservedObject var viewModel: SettingViewModel
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    profileImage
                    VStack(alignment: .leading) {
                        Text(viewModel.userInfo.nickname)
                            .font(.title)
                            .padding(.bottom, 4)
                        Text("Followers: \(viewModel.userInfo.followers)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Following: \(viewModel.userInfo.following)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                }.frame(maxHeight: 150)
                
                List(SettingSection.allCases, id: \.rawValue) { item in
                    switch item {
                    case .licence:
                        NavigationLink {
                            CarteViewControllerRepresentation()
                        } label: {
                            Text("\(item.rawValue)")
                        }
                    case .signOut:
                        Button {
                            self.showingAlert = true
                        } label: {
                            Text("\(item.rawValue)")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Setting"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showingAlert) {
            logoutAlert
        }
    }
    
    var profileImage: some View {
        Image(uiImage: viewModel.profileImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .mask(Circle())
            .padding()
    }
    
    var logoutAlert: Alert {
        Alert(title: Text("Sign Out"), message: Text("Are you sure you want to logout?"), primaryButton: .destructive(Text("OK"), action: {
            viewModel.logout()
        }), secondaryButton: .cancel(Text("Cancel")))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: SettingViewModel(usecase: Usecase(), sceneCoordinator: SceneCoordinator(window: UIApplication.shared.delegate!.window!!)))
    }
}

struct CarteViewControllerRepresentation: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return CarteViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
