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
    static private var cacheURL: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    class func load(from imageURL: String) -> Driver<UIImage?> {
        return Observable.create{ emitter in
            guard let fileName = URL(string: imageURL)?.lastPathComponent else {
                emitter.onError(NetworkError.imageURL)
                return Disposables.create()
            }
            
            if let cache = hasCache(fileName: fileName) {
                let image = UIImage(contentsOfFile: cache)
                
                emitter.onNext(image)
                emitter.onCompleted()
                return Disposables.create()
            }
            
            let request = downloadRequest(of: imageURL, fileName: fileName)
            request.responseURL { response in
                if response.error == nil, let filePath = response.fileURL?.path {
                    let image = UIImage(contentsOfFile: filePath)

                    emitter.onNext(image)
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
        .asDriver(onErrorJustReturn: nil)
    }
    
    class private func hasCache(fileName: String) -> String? {
        let expectedPath = cacheURL.path + "/\(fileName)"
        return FileManager.default.fileExists(atPath: expectedPath) ? expectedPath : nil
    }

    class private func downloadRequest(of imageURL: String, fileName: String) -> DownloadRequest {
        let destination: DownloadRequest.Destination = { _,_ in
            let fileURL = ImageLoader.cacheURL.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        return AF.download(imageURL, to: destination)
    }
}
