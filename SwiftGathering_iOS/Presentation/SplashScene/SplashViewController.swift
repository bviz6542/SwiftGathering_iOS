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
        Observable.zip(
            moveIconImageDownwards(), showIndicator()
        )
        .take(1)
        .subscribe(
            with: self,
            onNext: { owner, _ in
                owner.splashViewModel.loginInitiateInput.onNext(())
            })
        .disposed(by: disposeBag)
        
        splashViewModel.loginSuccessOutput
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.navigateToTabBar()
            })
            .disposed(by: disposeBag)
        
        splashViewModel.loginErrorOutput
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.coordinator?.navigateToLogin()
            })
            .disposed(by: disposeBag)
    }
    
    private func moveIconImageDownwards() -> Observable<Void> {
        Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError())
                return Disposables.create()
            }
            self.view.layoutIfNeeded()
            NSLayoutConstraint.deactivate([self.formerImageYOffset])
            UIView.animate(withDuration: 2, animations: { [weak self] in
                if let self = self {
                    NSLayoutConstraint.activate([self.latterImageYOffset])
                    self.view.layoutIfNeeded()
                }
            }, completion: { _ in
                observer.onNext(())
            })
            return Disposables.create()
        }
    }
    
    private func showIndicator() -> Observable<Void> {
        return Observable.create { [weak self] observer in
            UIView.animate(withDuration: 1.3, delay: 0.7, animations: {
                self?.activityIndicator.alpha = 1
            }, completion: { _ in
                observer.onNext(())
            })
            return Disposables.create()
        }
    }
}
