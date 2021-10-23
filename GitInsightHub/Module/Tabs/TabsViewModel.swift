//
//  TabsViewModel.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import Foundation
import RxSwift
import RxCocoa

class TabsViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
        let tabBarItems: Driver<[TabBarItem]>
    }
    
    let authorized: Bool
    
    init(authorized: Bool, usecase: GithubAPI, sceneCoordinator: SceneCoordinatorType) {
        self.authorized = authorized
        super.init(usecase: usecase, sceneCoordinator: sceneCoordinator)
    }
    
    func transform(input: Input) -> Output {
        let tabBarItems = Observable.combineLatest(input.trigger, Observable.just(authorized)) { $1 }
            .map({ authorized -> [TabBarItem] in
                if authorized {
                    return [.trand, .profile]
                } else {
                    return [.trand, .login]
                }
            }).asDriver(onErrorJustReturn: [])
        
        return Output(tabBarItems: tabBarItems)
    }
    
}