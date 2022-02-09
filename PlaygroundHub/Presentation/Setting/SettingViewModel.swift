//
//  SettingViewModel.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2022/02/08.
//

import SwiftUI
import RxSwift

enum SettingSection: String, CaseIterable {
    case licence = "Open Source License"
    case signOut = "Sign Out"
}

class SettingViewModel: ViewModel, ObservableObject {
    @Published var userInfo: User
    @Published var profileImage: UIImage
    
    init(usecase: GithubAPI, sceneCoordinator: SceneCoordinatorType) {
        self.userInfo = User.EMPTY
        self.profileImage = UIImage()
        super.init(usecase: usecase, sceneCoordinator: sceneCoordinator)
        let requestImageData = PublishSubject<String>()
        
        usecase.getUser()
            .subscribe { result in
                
                switch result {
                case .success(let user):
                    self.userInfo = user
                    requestImageData.onNext(user.imageURL)
                default:
                    break
                }
            }.disposed(by: rx.disposeBag)
        
        requestImageData
            .flatMap({ ImageLoader.load(from: $0) })
            .subscribe { result in
                switch result {
                case .next(let image):
                    self.profileImage = image ?? UIImage()
                default:
                    break
                }
            }.disposed(by: rx.disposeBag)
    }
    
    func logout() {
        AuthManager.shared.deleteToken()
        transitionOauthScene()
    }
    
    func transitionOauthScene() {
        let oauthViewModel = OAuthViewModel(usecase: usecase, sceneCoordinator: sceneCoordinator)
        let scene = Scene.oauth(oauthViewModel)
        
        sceneCoordinator.transition(to: scene, using: .root, animated: true)
    }
}
