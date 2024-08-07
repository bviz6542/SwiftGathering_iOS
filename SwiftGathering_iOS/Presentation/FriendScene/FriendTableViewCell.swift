//
//  FriendTableViewCell.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var currentlySelectedImageView: UIImageView!
    
    func setupNormalModeUI(using friendInfoUIModel: FriendInfoUIModel) {
        hideSelectedView()
        setupUI(using: friendInfoUIModel)
    }
    
    func setupGatheringModeUI(using friendInfoUIModel: FriendInfoUIModel) {
        showSelectedView(using: friendInfoUIModel)
        setupUI(using: friendInfoUIModel)
    }
    
    private func setupUI(using friendInfoUIModel: FriendInfoUIModel) {
        let (name, id) = (friendInfoUIModel.friendInfo.name, String(friendInfoUIModel.friendInfo.id))
        let fullText = "\(name)  \(id)"
        let attributedText = NSMutableAttributedString(string: fullText)
        let nameRange = (fullText as NSString).range(of: name)
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17.0), range: nameRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: nameRange)
        let idRange = (fullText as NSString).range(of: id)
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 12.0), range: idRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor.lightGray, range: idRange)
        nameLabel.attributedText = attributedText
        
        userImageView.image = UIImage(systemName: "person.fill")
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        userImageView.layer.masksToBounds = false
        userImageView.clipsToBounds = true
        userImageView.layoutIfNeeded()
    }
    
    private func showSelectedView(using friendInfoUIModel: FriendInfoUIModel) {
        selectedView.isHidden = false
        currentlySelectedImageView.isHidden = !friendInfoUIModel.isSelected
    }
    
    private func hideSelectedView() {
        selectedView.isHidden = true
    }
}
