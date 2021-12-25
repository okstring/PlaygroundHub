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
    }
    
    let selectedIndex = PublishSubject<Void>()
    
    init(usecase: GithubAPI, sceneCoordinator: SceneCoordinatorType) {
        super.init(usecase: usecase, sceneCoordinator: sceneCoordinator)
    }
    
    func transform(input: Input) -> Output {
        let sceneCoordinator = sceneCoordinator
        
        selectedIndex
            .subscribe(onNext: {
                sceneCoordinator.transition()
            }).disposed(by: rx.disposeBag)
        
        return Output()
    }
    
}
