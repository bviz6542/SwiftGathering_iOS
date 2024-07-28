//
//  FriendViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class FriendViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendSelectingModeForGathering: UIButton!
    @IBOutlet weak var addFriendsButton: UIButton!
    @IBOutlet weak var gatheringStartButton: UIButton!
    @IBOutlet weak var gatheringCancelButton: UIButton!
    
    private let viewModel: FriendViewModel
    private let disposeBag = DisposeBag()
    private var activityIndicator: ActivityIndicator?
    
    init(friendViewModel: FriendViewModel) {
        self.viewModel = friendViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        
        bind()
        viewModel.initializeData()
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
    
    private func bind() {
        viewModel.event.asSignal()
            .emit(onNext: { [weak self] event in
                switch event {
                case .onUpdateFriendInfos: self?.tableView.reloadData()
                case .onFetchFailFriendInfos(_): self?.showFetchingFriendInfosFailed()
                case .onCreateFailGathering(_): self?.showCreatingGatheringFailed()
                case .onStartLoading: self?.showIndicator()
                case .onEndLoading: self?.hideIndicator()
                case .onToggleViewMode(let viewMode): self?.updateViewMode(to: viewMode)
                }
            })
            .disposed(by: disposeBag)
        
        friendSelectingModeForGathering.rx.tap
            .bind(onNext: { [weak self] in
                self?.viewModel.toggleViewMode()
            })
            .disposed(by: disposeBag)
        
        addFriendsButton.rx.tap
            .bind(onNext: {
                ///
                ///
                ///
            })
            .disposed(by: disposeBag)
        
        gatheringStartButton.rx.tap.asSignal()
            .emit(onNext: { [weak self] in
                self?.viewModel.startGathering()
            })
            .disposed(by: disposeBag)
        
        gatheringCancelButton.rx.tap.asSignal()
            .emit(onNext: { [weak self] in
                self?.viewModel.cancelGathering()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateViewMode(to viewMode: FriendViewMode) {
        tableView.reloadData()
        switch viewMode {
        case .gathering:
            friendSelectingModeForGathering.isHidden = true
            addFriendsButton.isHidden = true
            gatheringStartButton.isHidden = false
            gatheringCancelButton.isHidden = false
            
        case .normal:
            friendSelectingModeForGathering.isHidden = false
            addFriendsButton.isHidden = false
            gatheringStartButton.isHidden = true
            gatheringCancelButton.isHidden = true
        }
    }
    
    private func showFetchingFriendInfosFailed() {
        present(AlertBuilder()
            .setTitle("Error")
            .setMessage("Failed fetching Friend list")
            .setProceedAction(title: "Yes", style: .default)
            .build(), animated: true)
    }
    
    private func showCreatingGatheringFailed() {
        present(AlertBuilder()
            .setTitle("Error")
            .setMessage("Failed creating Gathering")
            .setProceedAction(title: "Yes", style: .default)
            .build(), animated: true)
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

extension FriendViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.friendInfoUIModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell
        else { return UITableViewCell() }
        
        let friendInfo = viewModel.friendInfoUIModelList[indexPath.row]
        switch viewModel.friendViewMode {
        case .normal: cell.setupNormalModeUI(using: friendInfo)
        case .gathering: cell.setupGatheringModeUI(using: friendInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectFriend(in: indexPath.row)
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
