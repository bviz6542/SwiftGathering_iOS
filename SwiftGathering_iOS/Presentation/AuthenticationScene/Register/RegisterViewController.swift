//
//  RegisterViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var coordinator: RegisterCoordinator?
    
    private var registerViewModel: RegisterViewModel
    
    init(registerViewModel: RegisterViewModel) {
        self.registerViewModel = registerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initiated via nib")
    }
    
    @IBAction func onTouchedSubmitButton(_ sender: UIButton) {
        guard let id = idTextField.text, let password = passwordTextField.text else { return }
        
        Task {
            let registerInfo = RegisterInfo(id: id, password: password, age: "", phoneNumber: "")
            await registerViewModel.register(using: registerInfo)
                .onFailure { error in
                    present(AlertBuilder()
                        .setTitle("Warning")
                        .setMessage("register failed\n\(error.localizedDescription)")
                        .build(), animated: true)
                }
                .onSuccess { _ in
                    coordinator?.navigateToLogin()
                }
        }
    }
}
