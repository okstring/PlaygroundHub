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
    let disposeBag = DisposeBag()
    
    struct Input {
        let query: Observable<String>
        let nextPage: Observable<String>
    }
    
    struct Output {
        let title: Driver<String>
        let repository: BehaviorRelay<[Repository]>
    }
    
    private var page = 1
    
    func transform(input: Input) -> Output {
        let title = title.asDriver(onErrorJustReturn: "")
        
        let repository = BehaviorRelay<[Repository]>(value: [Repository]())
        
        input.query
            .do(onNext: { _ in self.page = 1 })
                .flatMap({ self.usecase.getSearchRepositoryResult(query: $0, page: self.page) })
            .asDriver(onErrorJustReturn: [Repository]())
            .drive(repository)
            .disposed(by: disposeBag)
        
        input.nextPage
            .do(onNext: { _ in self.page += 1 })
                .flatMap({ self.usecase.getSearchRepositoryResult(query: $0, page: self.page) })
                .map({ repository.value + $0 })
                .asDriver(onErrorJustReturn: [Repository]())
                .drive(repository)
                .disposed(by: disposeBag)
        
                
        return Output(title: title, repository: repository)
    }
    
    func getSearchRepositoryResult(query: String, page: Int) -> Single<[Repository]> {
        self.page = page
        return usecase.getSearchRepositoryResult(query: query, page: page)
    }
}
