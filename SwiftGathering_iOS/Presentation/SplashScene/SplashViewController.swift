//
//  SplashViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/17/24.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var formerImageYOffset: NSLayoutConstraint!
    @IBOutlet weak var latterImageYOffset: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveIconImageDownwards()
        showIndicator()
    }
    
    private func moveIconImageDownwards() {
        view.layoutIfNeeded()
        NSLayoutConstraint.deactivate([formerImageYOffset])
        UIView.animate(withDuration: 2) { [weak self] in
            if let newConstraint = self?.latterImageYOffset {
                NSLayoutConstraint.activate([newConstraint])
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func showIndicator() {
        UIView.animate(withDuration: 1, delay: 1) { [weak self] in
            self?.activityIndicator.alpha = 1
        }
    }
}
