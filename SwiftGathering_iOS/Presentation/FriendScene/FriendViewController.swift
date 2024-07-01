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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var gatheringButton: UIButton!
    @IBOutlet weak var addFriendsButton: UIButton!
    
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
        
//        headerView.isUserInteractionEnabled = true
//        gatheringButton.isUserInteractionEnabled = true
//        addFriendsButton.isUserInteractionEnabled = true
    }
    
    private func bind() {
        friendViewModel
            .friendInfosSuccessSubject
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "FriendTableViewCell", cellType: FriendTableViewCell.self)) { (row, element, cell) in
                cell.setupUI(using: element)
            }
            .disposed(by: disposeBag)
        
        friendViewModel
            .friendInfosFailureSubject
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, error in
                    owner.present(AlertBuilder()
                        .setTitle("Error")
                        .setMessage("Failed fetching Friend list")
                        .setProceedAction(title: "Yes", style: .default)
                        .build(), animated: true)
                })
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
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        gatheringButton.rx
            .tap
            .bind(onNext: { _ in
                print("gatheringButton")
            })
            .disposed(by: disposeBag)
        
        addFriendsButton.rx
            .tap
            .bind(onNext: { _ in
                print("addFriendsButton")
            })
            .disposed(by: disposeBag)
        
        confirmSubject
            .subscribe(onNext: { [weak self] friendInfo in
                print("wow: \(friendInfo)")
            })
            .disposed(by: disposeBag)
        
        friendViewModel
            .friendListInitiateInput.onNext(())
    }
}

extension FriendViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        0
    }
}
