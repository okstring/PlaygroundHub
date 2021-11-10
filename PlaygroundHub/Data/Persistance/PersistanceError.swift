//
//  PersistanceError.swift
//  GitInsightHub
//
//  Created by Issac on 2021/11/04.
//

import Foundation

enum PersistanceError: Error {
    case noResult
}

extension PersistanceError: CustomStringConvertible {
    var description: String {
        switch self {
        case .noResult:
            return "검색 결과를 찾을 수 없습니다"
        }
    }
}
