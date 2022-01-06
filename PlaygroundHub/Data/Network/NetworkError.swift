//
//  NetworkError.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation

enum NetworkError: Error {
    case internet
    case noResult
    case redirection
    case notAllowed
    case server
    case unknown
    case login
    case imageURL
    case invalidRequest
    case saveFailed
}

extension NetworkError: CustomStringConvertible {
    var description: String {
        switch self {
        case .internet:
            return "인터넷 연결을 확인해주세요"
        case .noResult:
            return "검색 결과를 찾을 수 없습니다"
        case .redirection:
            return "리다이렉션으로 추가 후속 조치가 필요합니다"
        case .notAllowed:
            return "잘못된 접근입니다"
        case .server:
            return "서버 상태가 불안정합니다"
        case .unknown:
            return "알 수 없는 문제가 발생했습니다"
        case .login:
            return "login이 필요합니다"
        case .imageURL:
            return "Image URL이 올바르지 않습니다"
        case .invalidRequest:
            return "Request 형식이 맞지 않습니다"
        case .saveFailed:
            return "image를 저장하는데 실패했습니다"
        }
    }
}
