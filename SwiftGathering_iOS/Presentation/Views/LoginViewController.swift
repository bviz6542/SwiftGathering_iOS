//
//  LoginViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    var loginViewModel: LoginViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        loginViewModel.loginResult
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.present(AlertBuilder()
                        .setTitle("Error")
                        .setMessage("failed to login\n\(error)")
                        .build(), animated: true)
                }
            }, receiveValue: { [weak self] success in
                if success {
                    self?.presentAlert(withTitle: "Success", message: "Login succeeded")
                } else {
                    self?.presentAlert(withTitle: "Error", message: "Invalid credentials")
                }
            })
            .store(in: &cancellables)
    }
    
    @IBAction func onTouchedSubmitButton(_ sender: Any) {
        guard let id = idTextField.text, let password = passwordTextField.text else { return }
        let loginInput = LoginInput(id: id, password: password)
        loginViewModel.login(with: loginInput)
//        Task {
//            let loginInput = LoginInput(id: id, password: password)
//            let _ :Result<EmptyOutput, Error> = await HTTPHandler()
//                .setPath(.login)
//                .setPort(8080)
//                .setMethod(.post)
//                .setRequestBody(loginInput)
//                .performNetworkOperation()
//                .onFailure { error in
//                    present(AlertBuilder()
//                        .setTitle("Error")
//                        .setMessage("failed to login\n\(error)")
//                        .build(), animated: true)
//                }
//                .onSuccess { [weak self] (output: EmptyOutput) in
//                    self?.present(AlertBuilder()
//                        .setTitle("Success")
//                        .setMessage("login succeeded")
//                        .setProceedAction(title: "Confirm", style: .default, handler: { [weak self] action in
//                            self?.navigationController?.popViewController(animated: true)
//                        })
//                        .build(), animated: true)
//                }
//        }
    }
    
    @IBAction func onTouchedRegisterButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}
