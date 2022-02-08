//
//  SettingView.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2022/02/08.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var viewModel: SettingViewModel
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            
            List(SettingSection.allCases, id: \.rawValue) { item in
                switch item {
                case .signOut:
                    Button {
                        self.showingAlert = true
                    } label: {
                        Text("\(item.rawValue)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Setting", displayMode: .inline)
            .alert(isPresented: $showingAlert) {
                logoutAlert
            }
        }
    }
    
    var logoutAlert: Alert {
        Alert(title: Text("Sign Out"), message: Text("Are you sure you want to logout?"), primaryButton: .destructive(Text("OK"), action: {
            viewModel.logout()
        }), secondaryButton: .cancel(Text("Cancel")))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: SettingViewModel(usecase: Usecase(), sceneCoordinator: SceneCoordinator(window: UIWindow())))
    }
}
