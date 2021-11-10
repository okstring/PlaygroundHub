//
//  CodableManager.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation

class CodableManager {
    private var decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    static let shared = CodableManager()
    
    private init() {}
    
    func stringDecode<T: Decodable>(string: String) -> T? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func encodeToString<T: Encodable>(object: T) -> String? {
        do {
            let data = try encoder.encode(object)
            return String(data: data, encoding: String.Encoding.utf8)
        } catch let error {
            print(error)
            return nil
        }
    }
}
