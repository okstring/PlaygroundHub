//
//  Int+NumberFormatter.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/24.
//

import Foundation

extension Int {
    var decimal: String {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        let result = numberformatter.string(from: NSNumber(value: self))!
        
        return result
    }
}
