//
//  TopicLabel.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/27.
//

import UIKit

class TopicLabel: UILabel {
    
    var attr: [NSAttributedString.Key: Any] {
        return [.backgroundColor: UIColor.paleBlue]
    }
    
    var paragraphStyle: NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        return paragraphStyle
    }
    
    func setAttributenTagString(arr: [String]) {
        let attributedTagString = arr.reduce(NSMutableAttributedString(string: "")) { result, tag in
            let attrStirng = NSAttributedString(string: "@\(tag)", attributes: attr)
            
            result.append(attrStirng)
            result.append(NSAttributedString(string: " "))
            
            return result
        }
        
        attributedTagString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0, attributedTagString.length))
        
        self.attributedText = attributedTagString
    }
}
