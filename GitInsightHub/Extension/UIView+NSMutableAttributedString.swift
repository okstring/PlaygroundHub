//
//  UIView+NSMutableAttributedString.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/24.
//

import UIKit

extension UIView {
    func makeAttributedString(normal: String, bold: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: normal)
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string: bold, attributes: attrs)

        attributedString.append(boldString)
        
        return attributedString
    }
}
