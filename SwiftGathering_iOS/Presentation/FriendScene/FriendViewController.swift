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
    @IBOutlet weak var gatheringModeButton: UIButton!
    @IBOutlet weak var addFriendsButton: UIButton!
    @IBOutlet weak var gatheringStartButton: UIButton!
    @IBOutlet weak var gatheringCancelButton: UIButton!
    
    private let friendViewModel: FriendViewModel
    private let disposeBag = DisposeBag()
    private var activityIndicator: ActivityIndicator?
    
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
        setupNavigationBar()
        
        bindViewModel()
        friendViewModel.onViewDidLoad.onNext(())
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        tableView.backgroundColor = .lightGray
    }
    
    private func bindViewModel() {
        Observable.combineLatest(
            friendViewModel.onFetchFriendInfos,
            friendViewModel.onChangeMode
        )
        .map { friendInfos, mode in
            friendInfos.map { ($0, mode) }
        }
        .bind(to: tableView.rx.items(cellIdentifier: "FriendTableViewCell", cellType: FriendTableViewCell.self)) { (row, element, cell) in
            let (friendInfo, mode) = element
            switch mode {
            case .normal:
                cell.setupNormalModeUI(using: friendInfo)

            case .gathering:
                cell.setupGatheringModeUI(using: friendInfo)
            }
        }
        .disposed(by: disposeBag)
        
        friendViewModel.onChangeMode
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] mode in
                switch mode {
                case .normal:
                    self?.gatheringModeButton.isHidden = false
                    self?.addFriendsButton.isHidden = false
                    self?.gatheringStartButton.isHidden = true
                    self?.gatheringCancelButton.isHidden = true
                    
                case .gathering:
                    self?.gatheringModeButton.isHidden = true
                    self?.addFriendsButton.isHidden = true
                    self?.gatheringStartButton.isHidden = false
                    self?.gatheringCancelButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        friendViewModel.onFetchFailFriendInfos
            .bind(onNext: { [weak self] error in
                self?.present(AlertBuilder()
                    .setTitle("Error")
                    .setMessage("Failed fetching Friend list")
                    .setProceedAction(title: "Yes", style: .default)
                    .build(), animated: true)
            })
            .disposed(by: disposeBag)
        
        friendViewModel.onCreateFailGathering
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] error in
                self?.present(AlertBuilder()
                    .setTitle("Error")
                    .setMessage("Failed creating Gathering")
                    .setProceedAction(title: "Yes", style: .default)
                    .build(), animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                self?.friendViewModel.onSelectFriendCell.onNext(indexPath.row)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        gatheringModeButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.friendViewModel.onTappedGatheringButton.onNext(())
            })
            .disposed(by: disposeBag)
        
        addFriendsButton.rx.tap
            .bind(onNext: {
                ///
                ///
                ///
            })
            .disposed(by: disposeBag)
        
        gatheringStartButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.friendViewModel.onTappedGatheringStartButton.onNext(())
            })
            .disposed(by: disposeBag)
        
        gatheringCancelButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.friendViewModel.onTappedGatheringCancelButton.onNext(())
            })
            .disposed(by: disposeBag)
        
        friendViewModel.onShowIndicator
            .bind(onNext: { [weak self] in
                self?.showIndicator()
            })
            .disposed(by: disposeBag)
        
        friendViewModel.onHideIndicator
            .bind(onNext: { [weak self] in
                self?.hideIndicator()
            })
            .disposed(by: disposeBag)
    }
    
    private func showIndicator() {
        activityIndicator = ActivityIndicator()
        activityIndicator?.show()
    }
    
    private func hideIndicator() {
        activityIndicator?.hide()
        activityIndicator = nil
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
