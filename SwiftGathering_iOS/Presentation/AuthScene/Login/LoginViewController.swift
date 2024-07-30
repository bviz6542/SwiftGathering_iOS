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
        
    let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
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
            .bind(onNext: { [weak self] in
                self?.login()
            })
            .disposed(by: disposeBag)
        
        viewModel.event.asSignal()
            .emit(onNext: { [weak self] event in
                switch event {
                case .onFailureLogin(let error): self?.showLoginFailed(dueTo: error)
                }
            })
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.viewModel.register()
            })
            .disposed(by: disposeBag)
    }
    
    private func login() {
        if let loginInfo = checkLoginTextFields() {
            viewModel.login(using: loginInfo)
        } else {
            showLoginTextFieldsAreEmpty()
        }
    }
    
    private func checkLoginTextFields() -> LoginInfo? {
        if let id = idTextField.text, let password = passwordTextField.text {
            return LoginInfo(loginId: id, loginPassword: password)
        } else {
            return nil
        }
    }
    
    private func showLoginTextFieldsAreEmpty() {
        present(AlertBuilder()
            .setTitle("Login Error")
            .setMessage("ID and Password must not be empty.")
            .build(), animated: true)
    }
    
    private func showLoginFailed(dueTo error: Error) {
        present(AlertBuilder()
            .setTitle("Login Error")
            .setMessage("\(error)\nTry once more")
            .build(), animated: true)
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
