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
        let repository: Observable<[Repository]>
    }
    
    func transform(input: Input) -> Output {
        let repository = Observable
            .combineLatest(usecase.getUserRepository().asObservable(), input.trigger) { user, _ in user }
            .share()
        
        return Output(repository: repository)
    }
    
}
