//
//  LoginViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTouchedSubmitButton(_ sender: Any) {
        guard let id = idTextField.text, let password = passwordTextField.text else { return }
        
        Task {
            let loginInput = LoginInput(id: id, password: password)
            
            await HTTPHandler()
                .setPath(.login)
                .setMethod(.get)
                .setRequestBody(loginInput)
                .performNetworkOperation()
                .onFailure { error in
                    present(AlertBuilder()
                        .setTitle("Error")
                        .setMessage("failed to login\n\(error)")
                        .build(), animated: true)
                }
                .onSuccess { (_: EmptyOutput) in }
            
        }
    }
}
