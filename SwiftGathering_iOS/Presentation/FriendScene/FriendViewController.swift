//
//  FriendViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import UIKit
import RxSwift

class FriendViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let friendViewModel: FriendViewModel
    private let disposeBag = DisposeBag()
    private let confirmSubject = PublishSubject<FriendInfo>()
    
    init(friendViewModel: FriendViewModel) {
        self.friendViewModel = friendViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
    }
    
    private func bind() {
        friendViewModel.friendListInitiateInput
            .onNext(())
        
        friendViewModel.friendInfosSuccessOutput
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "FriendTableViewCell", cellType: FriendTableViewCell.self)) { (row, element, cell) in
                cell.userImageView.image = UIImage(systemName: "person.fill")
                cell.nameLabel.text = String(element.name)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(FriendInfo.self)
            .subscribe(onNext: { [weak self] friendInfo in
                self?.present(AlertBuilder()
                    .setTitle("")
                    .setMessage("Do you want to start gathering?")
                    .setCancelAction(title: "No", style: .destructive)
                    .setProceedAction(title: "Yes", style: .default, handler: { [weak self] action in
                        self?.confirmSubject.onNext(friendInfo)
                    })
                    .build(), animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        confirmSubject
            .subscribe(onNext: { [weak self] friendInfo in
                print("wow: \(friendInfo)")
            })
            .disposed(by: disposeBag)
    }
}

extension FriendViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
