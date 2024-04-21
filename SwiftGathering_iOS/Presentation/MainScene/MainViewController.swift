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
        
//        Task {
//            do {
//                let (loginID, loginPassword) = try fetchLocalLoginInfo()
//                try await login(with: loginID, and: loginPassword)
//                
//            } catch LoginError.loginInfoSearchFailed {
//                navigationController?.pushViewController(RegisterViewController(), animated: true)
//                
//            } catch let error as HTTPError {
//                present(AlertBuilder()
//                    .setTitle("Error")
//                    .setMessage("failed to login\n\(error)")
//                    .setProceedAction(title: "Confirm", style: .default, handler: { [weak self] action in
//                        
//                        let httpHandler = HTTPHandler()
//                        let userDefaults = UserDefaults.standard
//                        let loginRepository = LoginRepository(httpHandler: httpHandler, userDefaults: userDefaults)
//                        let loginUseCase = LoginUseCase(loginRepository: loginRepository)
//                        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
//                        self?.navigationController?.pushViewController(LoginViewController(loginViewModel: loginViewModel), animated: true)
//                    })
//                    .build(), animated: true)
//                
//            } catch {}
//        }
    }
    
    private func fetchLocalLoginInfo() throws -> (String, String) {
        guard let loginID = UserDefaults.standard.object(forKey: "loginID") as? String,
              let loginPassword = UserDefaults.standard.object(forKey: "loginPassword") as? String
        else { throw LoginError.loginInfoSearchFailed }
        return (loginID, loginPassword)
    }
    
    private func login(with id: String, and password: String) async throws {
        let loginInput = LoginInput(id: id, password: password)
        try await HTTPHandler()
            .setPath(.login)
            .setPort(8080)
            .setMethod(.post)
            .setRequestBody(loginInput)
            .send(expecting: EmptyOutput.self)
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
