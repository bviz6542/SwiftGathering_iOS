//
//  MainViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.pushViewController(MapViewController(), animated: true)
        
        Task {
            do {
                let (loginID, loginPassword) = try fetchLocalLoginInfo()
                try await login(with: loginID, and: loginPassword)
                
            } catch LoginError.neverLoggedIn {
                navigationController?.pushViewController(RegisterViewController(), animated: true)
                
            } catch let error as HTTPError {
                present(AlertBuilder()
                    .setTitle("Error")
                    .setMessage("failed to login\n\(error)")
                    .setProceedAction(title: "Confirm", style: .default, handler: { [weak self] action in
                        self?.navigationController?.pushViewController(LoginViewController(), animated: true)
                    })
                    .build(), animated: true)
                
            } catch {}
        }
    }
    
    private func fetchLocalLoginInfo() throws -> (String, String) {
        guard let loginID = UserDefaults.standard.object(forKey: "loginID") as? String,
              let loginPassword = UserDefaults.standard.object(forKey: "loginPassword") as? String
        else { throw LoginError.neverLoggedIn }
        return (loginID, loginPassword)
    }
    
    private func login(with id: String, and password: String) async throws {
        let loginInput = LoginInput(id: id, password: password)
        try await HTTPHandler()
            .setPath(.login)
            .setPort(8080)
            .setMethod(.post)
            .setRequestBody(loginInput)
            .performNetworkOperation()
            .onSuccess { (output: EmptyOutput) in
                saveLoginInfoToLocal(with: id, and: password)
            }
            .getOrThrow()
    }
    
    private func saveLoginInfoToLocal(with id: String, and password: String) {
        UserDefaults.standard.setValue(id, forKey: "loginID")
        UserDefaults.standard.setValue(password, forKey: "loginPassword")
    }
}

