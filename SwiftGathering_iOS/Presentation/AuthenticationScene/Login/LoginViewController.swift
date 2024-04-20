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

    weak var coordinator: LoginCoordinator?
    
    private var loginViewModel: LoginViewModel
//    private var cancellables = Set<AnyCancellable>()
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        bindViewModel()
//    }
//    
//    private func bindViewModel() {
//        loginViewModel.loginResult
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                if case .failure(let error) = completion {
//                    self?.present(AlertBuilder()
//                        .setTitle("Error")
//                        .setMessage("failed to login\n\(error)")
//                        .build(), animated: true)
//                }
//            }, receiveValue: { [weak self] _ in
//                self?.present(AlertBuilder()
//                    .setTitle("Success")
//                    .setMessage("login succeeded")
//                    .setProceedAction(title: "Confirm", style: .default, handler: { [weak self] action in
//                        self?.navigationController?.popViewController(animated: true)
//                    })
//                        .build(), animated: true)
//            })
//            .store(in: &cancellables)
//    }
    
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
                    coordinator?.navigateToMap()
                }
        }
    }
    
    @IBAction func onTouchedRegisterButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}
