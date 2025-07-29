//
//  UIImage+Extension.swift
//  TalknLike
//
//  Created by 이상수 on 7/29/25.
//

import UIKit

extension UIImage {
    
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
}
