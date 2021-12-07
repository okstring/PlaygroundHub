//
//  ProfileViewModel.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/21.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModel, ViewModelType {
    struct Input {
        let appearTrigger: Observable<Void>
        let repositoryRefresh: Observable<Void>
        let starredRefresh: Observable<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let userRepository: Driver<[Repository]>
        let starredRespository: Driver<[Repository]>
        let refreshing: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let usecase = usecase
        let refresh = PublishSubject<Bool>()
        
        let title = title.asDriver(onErrorJustReturn: "")
        
        
        
        let userRepository = input.repositoryRefresh
            .withLatestFrom(input.appearTrigger) { appear, _ in appear }
            .do(onNext: { refresh.onNext(true) })
            .flatMap{ usecase.getUserRepository() }
            .do(onNext: { _ in refresh.onNext(false) })
            .asDriver(onErrorJustReturn: [Repository]())
                
        let starredRepository = input.starredRefresh
            .withLatestFrom(input.appearTrigger) { appear, _ in appear }
            .do(onNext: { refresh.onNext(true) })
            .flatMap({ usecase.getStarred() })
            .do(onNext: { _ in refresh.onNext(false) })
            .asDriver(onErrorJustReturn: [Repository]())
                
        let refreshing = refresh.distinctUntilChanged()
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
                
        return Output(title: title,
                      userRepository: userRepository,
                      starredRespository: starredRepository,
                      refreshing: refreshing)
    }
}