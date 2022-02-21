//
//  ImageLoader.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/27.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

final class ImageLoader {
    static func load(from imageURL: String) -> Driver<UIImage?> {
        return Single.create { single in
            guard let fileName = URL(string: imageURL)?.lastPathComponent else {
                single(.failure(NetworkError.imageURL))
                return Disposables.create()
            }
            
            let savedEtag = getEtag(of: fileName)
            
            guard let request = setRequest(url: imageURL, Etag: savedEtag) else {
                single(.failure(NetworkError.invalidRequest))
                return Disposables.create()
            }
            
            AF.request(request).response { response in
                guard let statusCode = response.response?.statusCode else {
                    return single(.failure(NetworkError.internet))
                }
                
                switch statusCode {
                case 200:
                    guard let data = response.data,
                          let responseHeader = response.response?.headers else {
                              return single(.failure(NetworkError.noResult))
                          }
                    guard let Etag = responseHeader.value(for: "Etag"),
                          saveImageData(of: data, fileName: fileName) else {
                              let image = UIImage(data: data)
                              return single(.success(image))
                          }
                    
                    saveEtag(of: fileName, Etag: Etag)
                    
                    let image = UIImage(data: data)
                    single(.success(image))
                    
                case 304:
                    guard let cache = hasCache(fileName: fileName) else {
                        return single(.failure(NetworkError.imageURL))
                    }
                    let image = UIImage(contentsOfFile: cache)
                    single(.success(image))
                    
                case 400..<500:
                    single(.failure(NetworkError.notAllowed))
                case 500...:
                    single(.failure(NetworkError.server))
                default:
                    single(.failure(NetworkError.unknown))
                }
            }
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .asDriver(onErrorJustReturn: UIImage())
    }
}

extension ImageLoader {
    static private var cacheURL: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    static private func setRequest(url: String, Etag: String) -> URLRequest? {
        var request = try? URLRequest(url: url, method: .get, headers: [HTTPHeader(name: "If-None-Match", value: "\(Etag)")])
        request?.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
    
    static private func saveImageData(of data: Data, fileName: String) -> Bool {
        let path = cacheURL.appendingPathComponent(fileName).path
        return FileManager.default.createFile(atPath: path, contents: data)
    }
    
    static private func hasCache(fileName: String) -> String? {
        let expectedPath = cacheURL.path + "/\(fileName)"
        return FileManager.default.fileExists(atPath: expectedPath) ? expectedPath : nil
    }
    
    static private func getEtag(of key: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    static private func saveEtag(of key: String, Etag: String) {
        return UserDefaults.standard.set(Etag, forKey: key)
    }
}
