//
//  Networking.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift
import Alamofire

final class NetworkManager {
    func get<T: Decodable>(type: T.Type,
                           endpoint: Endpoint,
                           needToken: Bool = false) -> Observable<T> {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return Observable.create() { emitter in
            AF.request(endpoint.URL,
                       method: endpoint.httpMethod,
                       parameters: endpoint.parameters,
                       encoding: URLEncoding.default,
                       headers: endpoint.headers,
                       interceptor: nil,
                       requestModifier: nil)
                .responseDecodable(of: type,
                                   decoder: decoder) { (dataResponse) in
                    guard let statusCode = dataResponse.response?.statusCode else {
                        return emitter.onError(NetworkError.internet)
                    }
                    switch statusCode {
                    case 200..<300:
                        guard let result = dataResponse.value else {
                            return emitter.onError(NetworkError.noResult)
                        }
                        emitter.onNext(result)
                        emitter.onCompleted()
                    case 300..<400:
                        emitter.onError(NetworkError.redirection)
                    case 400..<500:
                        emitter.onError(NetworkError.notAllowed)
                    case 500...:
                        emitter.onError(NetworkError.server)
                    default:
                        emitter.onError(NetworkError.unknown)
                    }
                }
            return Disposables.create()
        }
    }
}

