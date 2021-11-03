//
//  StarredLoader.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/24.
//

import Foundation
import RxSwift
import Alamofire

final class StarredLoader {
    static func starred(endpoint: Endpoint) -> Single<Bool> {
        
        return Single<Bool>.create() { emitter in
            if !AuthManager.shared.hasValidToken {
                emitter(.success(false))
            } else {
                AF.request(endpoint.URL,
                           method: endpoint.httpMethod,
                           parameters: endpoint.parameters,
                           encoding: URLEncoding.default,
                           headers: endpoint.headers,
                           interceptor: nil,
                           requestModifier: nil)
                    .response { dataResponse in
                        guard let statusCode = dataResponse.response?.statusCode else {
                            emitter(.success(false))
                            return
                        }
                        switch statusCode {
                        case 204:
                            emitter(.success(true))
                        case 404:
                            emitter(.success(false))
                        default:
                            emitter(.success(false))
                        }
                    }
            }
            
            return Disposables.create()
        }
    }
}
