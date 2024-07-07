//
//  ActivityIndicator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

import UIKit

class ActivityIndicator {
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    func show() {
        DispatchQueue.main.async {
            if let delegate = UIApplication.shared.delegate as? SceneDelegate,
               let window = delegate.window {
                window.addSubview(self.activityIndicator)
                self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    self.activityIndicator.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                    self.activityIndicator.centerYAnchor.constraint(equalTo: window.centerYAnchor)
                ])
                self.activityIndicator.startAnimating()
                window.isUserInteractionEnabled = false
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            if let delegate = UIApplication.shared.delegate as? SceneDelegate,
               let window = delegate.window {
                window.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }
        }
    }
}
