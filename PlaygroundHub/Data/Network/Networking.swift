//
//  Networking.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

protocol NetworkingProtocol {
    
    func request<T: Decodable>(type: T.Type, endpoint: Endpoint) -> Single<T>
    
    func createAccessToken(endpoint: Endpoint) -> Single<Token>
}

final class Networking: NetworkingProtocol {
    
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func request<T: Decodable>(type: T.Type,
                           endpoint: Endpoint) -> Single<T> {
        return Single.create() { single in
            AF.request(endpoint.URL,
                       method: endpoint.httpMethod,
                       parameters: endpoint.parameters,
                       encoding: URLEncoding.default,
                       headers: endpoint.headers,
                       interceptor: nil,
                       requestModifier: nil)
                .responseDecodable(of: T.self, decoder: self.jsonDecoder) { (dataResponse) in
                    guard let statusCode = dataResponse.response?.statusCode else {
                        return single(.failure(NetworkError.internet))
                    }
                    switch statusCode {
                    case 200..<300:
                        guard let result = dataResponse.value else {
                            return single(.failure(NetworkError.noResult))
                        }
                        single(.success(result))
                    case 300..<400:
                        single(.failure(NetworkError.redirection))
                    case 400..<500:
                        single(.failure(NetworkError.notAllowed))
                    case 500...:
                        single(.failure(NetworkError.server))
                    default:
                        single(.failure(NetworkError.unknown))
                    }
                }
            return Disposables.create()
        }
    }
    
    func createAccessToken(endpoint: Endpoint) -> Single<Token> {
        return Single.create { single in
            AF.request(endpoint.createAccessTokenURL,
                       method: endpoint.httpMethod,
                       parameters: endpoint.parameters,
                       encoding: URLEncoding.default,
                       headers: endpoint.headers)
                .responseDecodable(of: Token.self, completionHandler: { response in
                    if let error = response.error {
                        single(.failure(error))
                        return
                    }
                    if let token = response.value {
                        single(.success(token))
                        return
                    }
                    single(.failure(RxError.unknown))
                })
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
    }
}

