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
    private var friendInfos: [FriendInfo] = []
    
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
        friendViewModel.friendInfos
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] infos in
                self?.friendInfos = infos
                self?.tableView.reloadData()
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        cell.idLabel.text = String(friendInfos[indexPath.row].id)
        cell.nameLabel.text = friendInfos[indexPath.row].name
        return cell
    }
}
