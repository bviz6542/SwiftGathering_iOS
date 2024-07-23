//
//  ProfileViewController.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 5/24/24.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    private let viewModel: ProfileViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        logoutButton.rx.tap
            .asSignal()
            .emit(onNext: { [weak self] in
                self?.viewModel.navigateToSplash()
            })
            .disposed(by: disposeBag)
    }
}
