//
//  TrandViewModel.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import Foundation
import RxSwift
import RxCocoa

class TrandViewModel: ViewModel, ViewModelType {
    struct Input {
        let query: Observable<String>
    }
    
    struct Output {
        let title: Driver<String>
        let repository: Driver<[Repository]>
    }
    
    func transform(input: Input) -> Output {
        let title = title.asDriver(onErrorJustReturn: "")
        
        let repository = input.query
            .flatMap({ self.usecase.getSearchRepositoryResult(query: $0, page: 1) })
            .asDriver(onErrorJustReturn: [Repository]())
        
        return Output(title: title, repository: repository)
    }
}
