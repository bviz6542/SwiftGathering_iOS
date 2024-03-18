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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTouchedSubmitButton(_ sender: UIButton) {
        guard let id = idTextField.text, let password = passwordTextField.text else { return }
        
        Task {
            let registerInput = RegisterInput(id: id, password: password)
            
            await HTTPHandler()
                .setPort(8080)
                .setPath(.register)
                .setMethod(.post)
                .setRequestBody(registerInput)
                .performNetworkOperation()
                .onFailure { error in
                    present(AlertBuilder()
                        .setTitle("Error")
                        .setMessage("failed to register\n\(error)")
                        .build(), animated: true)
                }
                .onSuccess { (_: EmptyOutput) in
                    saveLoginInfoToLocal(with: id, and: password)
                    present(AlertBuilder()
                        .setTitle("Success")
                        .setMessage("register succeeded")
                        .setProceedAction(title: "Confirm", style: .default, handler: { [weak self] action in
                            self?.navigationController?.popViewController(animated: true)
                        })
                        .build(), animated: true)
                }
            
        }
    }
    
    private func saveLoginInfoToLocal(with id: String, and password: String) {
        UserDefaults.standard.setValue(id, forKey: "loginID")
        UserDefaults.standard.setValue(password, forKey: "loginPassword")
    }
}
