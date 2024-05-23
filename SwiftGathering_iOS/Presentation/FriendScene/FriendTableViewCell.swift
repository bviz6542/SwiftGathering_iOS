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
}
