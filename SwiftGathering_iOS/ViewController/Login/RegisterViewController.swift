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
                .setPath(.register)
                .setMethod(.get)
                .setRequestBody(registerInput)
                .performNetworkOperation()
                .onFailure { error in
                    present(AlertBuilder()
                        .setTitle("Error")
                        .setMessage("failed to register\n\(error)")
                        .build(), animated: true)
                }
                .onSuccess { (_: EmptyOutput) in
                    present(AlertBuilder()
                        .setTitle("Success")
                        .setMessage("register succeeded")
                        .build(), animated: true)
                }
            
        }
    }
}
