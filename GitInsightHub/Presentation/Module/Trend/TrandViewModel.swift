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
        
    }
    
    struct Output {
        let title: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let title = title.asDriver(onErrorJustReturn: "")
        
        return Output(title: title)
    }
}
