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
    
    weak var coordinator: RootCoordinator?
    
    private var splashViewModel: SplashViewModel
    
    init(splashViewModel: SplashViewModel) {
        self.splashViewModel = splashViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            moveIconImageDownwards()
            showIndicator()
            
            await login()
        }
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
        UIView.animate(withDuration: 1.3, delay: 0.7) { [weak self] in
            self?.activityIndicator.alpha = 1
        }
    }
    
    private func login() async {
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            try await splashViewModel.loginWithPreviousLoginInfo().getOrThrow()
            coordinator?.navigateToTabBar()
            
        } catch {
            coordinator?.navigateTLogin()
        }
    }
}
