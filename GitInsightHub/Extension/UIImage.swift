//
//  UIImage.swift
//  GitInsightHub
//
//  Created by Issac on 2021/11/02.
//

import UIKit

extension UIImage {
    func resize(newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
}

