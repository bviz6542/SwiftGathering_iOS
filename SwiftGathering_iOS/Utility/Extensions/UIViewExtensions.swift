//
//  UIViewExtensions.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

import UIKit

extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor { return UIColor(cgColor: color) }
            else { return nil }
        }
        set(newColor) {
            if let newColor = newColor {
                self.layer.borderColor = newColor.cgColor
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(newWidth) {
            self.layer.borderWidth = newWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(newValue) {
            self.layer.cornerRadius = newValue
        }
    }
}
