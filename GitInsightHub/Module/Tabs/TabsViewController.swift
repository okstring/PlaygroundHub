//
//  TabsViewController.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController
import NSObject_Rx
import SnapKit

enum TabBarItem {
    case trand, login, profile
    
    func viewController(sceneCoordinator: SceneCoordinatorType, usecase: GithubAPI) -> UIViewController {
        switch self {
        case .trand:
            var vc = TrandViewController()
            let nav = UINavigationController(rootViewController: vc)
            let viewModel = TrandViewModel(usecase: usecase, sceneCoordinator: sceneCoordinator)
            vc.bind(viewModel: viewModel)
            return nav
        case .login:
            var vc = OAuthViewController()
            let viewModel = OAuthViewModel(usecase: usecase, sceneCoordinator: sceneCoordinator)
            vc.bind(viewModel: viewModel)
            return vc
        case .profile:
            var vc = ProfileViewController()
            let nav = UINavigationController(rootViewController: vc)
            let viewModel = ProfileViewModel(usecase: usecase, sceneCoordinator: sceneCoordinator)
            vc.bind(viewModel: viewModel)
            return nav
        }
    }
    
    var image: UIImage? {
        switch self {
        case .trand:
            return UIImage(systemName: "chart.line.uptrend.xyaxis")
        case .login:
            return UIImage(systemName: "person")
        case .profile:
            return UIImage(systemName: "person.fill")
        }
    }
    
    var title: String {
        switch self {
        case .trand:
            return "트렌드"
        case .login:
            return "마이 페이지"
        case .profile:
            return "마이 페이지"
        }
    }
}

class TabsViewController: UITabBarController, ViewModelBindableType {
    var viewModel: TabsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI() {
        tabBar.backgroundColor = .systemGray6
    }
    
    func bindViewModel() {
        let input = TabsViewModel.Input(trigger: rx.viewWillAppear.mapToVoid().asObservable())
        let output = viewModel.transform(input: input)
        
        output.tabBarItems
            .map({ tabBarItems in
                tabBarItems.map({ [weak self] tabBarItem -> UIViewController in
                    guard let self = self else {
                        return UIViewController()
                    }
                    
                    let vc = tabBarItem.viewController(sceneCoordinator: self.viewModel.sceneCoordinator, usecase: self.viewModel.usecase)
                    
                    vc.tabBarItem = UITabBarItem(title: tabBarItem.title, image: tabBarItem.image, selectedImage: tabBarItem.image)

                    return vc
                })
            }).drive(rx.viewControllers)
            .disposed(by: rx.disposeBag)
        
        
        Observable.combineLatest(rx.viewDidAppear, loggedIn) { $1 }
            .subscribe(onNext: { [weak self] isLoggedIn in
                self?.selectedIndex = isLoggedIn ? 1 : 0
            }).disposed(by: rx.disposeBag)
    }
}
