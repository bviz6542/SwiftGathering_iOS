//
//  LoginViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var keyboardHiddenConstraints: [NSLayoutConstraint]!
    @IBOutlet var keyboardShownConstraints: [NSLayoutConstraint]!
    
    weak var coordinator: LoginCoordinator?
    
    private let loginViewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        registerKeyboardNotifications()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    private func bind() {
        loginButton.rx.tap
            .withLatestFrom(Observable.combineLatest(idTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty))
            .flatMap { [weak self] id, password -> Observable<LoginInfo> in
                guard let self = self else { return Observable.empty() }
                if id.isEmpty || password.isEmpty {
                    self.present(AlertBuilder()
                        .setTitle("Login Error")
                        .setMessage("ID and Password must not be empty.")
                        .build(), animated: true)
                    return Observable.empty()
                } else {
                    return Observable.just(LoginInfo(loginId: id, loginPassword: password))
                }
            }
            .bind(to: loginViewModel.loginTap)
            .disposed(by: disposeBag)
        
        loginViewModel.loginState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.navigateToTabBar()
            }, onError: { [weak self] _ in
                self?.present(AlertBuilder()
                    .setTitle("Login Error")
                    .setMessage("Try once more")
                    .build(), animated: true)
            })
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.navigateToRegister()
            })
            .disposed(by: disposeBag)
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            if let keyboardShownConstraints = self?.keyboardShownConstraints,
               let keyboardHiddenConstraints = self?.keyboardHiddenConstraints {
                NSLayoutConstraint.deactivate(keyboardHiddenConstraints)
                NSLayoutConstraint.activate(keyboardShownConstraints)
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            if let keyboardHiddenConstraints = self?.keyboardHiddenConstraints,
               let keyboardShownConstraints = self?.keyboardShownConstraints {
                NSLayoutConstraint.deactivate(keyboardShownConstraints)
                NSLayoutConstraint.activate(keyboardHiddenConstraints)
                self?.view.layoutIfNeeded()
            }
        }
    }
}
