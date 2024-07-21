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
        
    private let viewModel: SplashViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
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
        .asSignal(onErrorSignalWith: .empty())
        .emit(onNext: { [weak self] _ in
            self?.viewModel.login()
        })
        .disposed(by: disposeBag)
    }
    
    private func moveIconImageDownwards() -> Observable<Void> {
        Observable.create { [weak self] observer in
            self?.deactivateFormerImageYOffset()
            UIView.animate(withDuration: 2, animations: { [weak self] in
                self?.activateLatterImageYOffset()
            }, completion: { _ in
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    private func deactivateFormerImageYOffset() {
        view.layoutIfNeeded()
        NSLayoutConstraint.deactivate([formerImageYOffset])
    }
    
    private func activateLatterImageYOffset() {
        NSLayoutConstraint.activate([latterImageYOffset])
        view.layoutIfNeeded()
    }
    
    private func showIndicator() -> Observable<Void> {
        return Observable.create { [weak self] observer in
            UIView.animate(withDuration: 1.3, delay: 0.7, animations: {
                self?.activityIndicator.alpha = 1
            }, completion: { _ in
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
