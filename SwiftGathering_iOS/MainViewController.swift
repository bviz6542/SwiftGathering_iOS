//
//  MainViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import UIKit

class MainViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let VC = DrawingViewController()
        VC.modalPresentationStyle = .overCurrentContext
        
        present(VC, animated: true)
//        present(ChattingViewController(), animated: true)
    }
}

