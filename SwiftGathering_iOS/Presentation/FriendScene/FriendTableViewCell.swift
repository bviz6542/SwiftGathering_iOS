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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews
            .filter { view in
                type(of: view).description() == "_UITableViewCellSeparatorView"
            }
            .forEach { view in
                view.alpha = 1.0
            }
    }
    
    func showSelectedView() {
        selectedView.isHidden = false
    }
    
    func hideSelectedView() {
        selectedView.isHidden = true
    }
    
    func showIsCurrentlySelected() {
        currentlySelectedImageView.isHidden = false
    }
    
    func showIsNotCurrentlySelected() {
        currentlySelectedImageView.isHidden = true
    }
}
