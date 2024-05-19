//
//  SplashViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/17/24.
//

import UIKit
import RxSwift

class SplashViewController: UIViewController {
    @IBOutlet weak var formerImageYOffset: NSLayoutConstraint!
    @IBOutlet weak var latterImageYOffset: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var coordinator: RootCoordinator?
    
    private let splashViewModel: SplashViewModel
    private let disposeBag = DisposeBag()
    
    init(splashViewModel: SplashViewModel) {
        self.splashViewModel = splashViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        Completable.zip(
            moveIconImageDownwards(), showIndicator()
        )
        .andThen(splashViewModel.loginState)
        .subscribe(
            onNext: { [weak self] _ in
                self?.coordinator?.navigateToTabBar()
            },
            onError: { [weak self] _ in
                self?.coordinator?.navigateToLogin()
            }
        )
        .disposed(by: disposeBag)
    }
    
    private func moveIconImageDownwards() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.completed)
                return Disposables.create()
            }
            
            self.view.layoutIfNeeded()
            NSLayoutConstraint.deactivate([self.formerImageYOffset])
            UIView.animate(withDuration: 2, animations: {
                NSLayoutConstraint.activate([self.latterImageYOffset])
                self.view.layoutIfNeeded()
            }, completion: { _ in
                completable(.completed)
            })
            
            return Disposables.create()
        }
    }
    
    private func showIndicator() -> Completable {
        return Completable.create { [weak self] completable in
            UIView.animate(withDuration: 1.3, delay: 0.7, animations: {
                self?.activityIndicator.alpha = 1
            }, completion: { _ in
                completable(.completed)
            })
            
            return Disposables.create()
        }
    }
}
