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
        let trigger: Observable<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let repository: Driver<[Repository]>
        let refreshing: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let usecase = usecase
        let refresh = PublishSubject<Bool>()
        
        let title = title.asDriver(onErrorJustReturn: "")
        
        let repository = input.trigger
            .do(onNext: { refresh.onNext(true) })
            .flatMap{ usecase.getUserRepository() }
            .do(onNext: { _ in refresh.onNext(false) })
            .asDriver(onErrorJustReturn: [Repository]())
                
                //TODO: - refresh delay 
            
        let refreshing = refresh.asDriver(onErrorJustReturn: false)
        
        return Output(title: title, repository: repository, refreshing: refreshing)
    }
}
