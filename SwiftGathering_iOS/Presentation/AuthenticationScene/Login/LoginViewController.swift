//
//  LoginViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var keyboardHiddenConstraints: [NSLayoutConstraint]!
    @IBOutlet var keyboardShownConstraints: [NSLayoutConstraint]!
    
    weak var coordinator: LoginCoordinator?
    
    private var loginViewModel: LoginViewModel
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
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
    
    @IBAction func onTouchedSubmitButton(_ sender: Any) {
        guard let id = idTextField.text, let password = passwordTextField.text
        else {
            present(AlertBuilder()
                .setTitle("Login Error")
                .setMessage("check input once more")
                .build(), animated: true)
            return
        }
        Task {
            let loginInfo = LoginInfo(loginID: id, loginPassword: password)
            await loginViewModel.login(using: loginInfo)
                .onFailure { error in
                    present(AlertBuilder()
                        .setTitle("Login Error")
                        .setMessage("try once more")
                        .build(), animated: true)
                }
                .onSuccess { _ in
                    coordinator?.navigateToTabBar()
                }
        }
    }
    
    @IBAction func onTouchedRegisterButton(_ sender: UIButton) {
        coordinator?.navigateToRegister()
    }
}
