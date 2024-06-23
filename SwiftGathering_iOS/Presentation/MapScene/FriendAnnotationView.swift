//
//  FriendAnnotationView.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 6/24/24.
//

import MapKit

class FriendAnnotationView: MKPinAnnotationView {
    static let identifier = "FriendAnnotationView"
    private let pinImageView = UIImageView(image: UIImage(systemName: "mappin"))
    private let label = UILabel()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        animatesDrop = true
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
//        frame = CGRect(x: 0, y: 0, width: 50, height: 60)
//        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
//
//        pinImageView.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
//        addSubview(pinImageView)
//
//        label.frame = CGRect(x: 0, y: 30, width: 50, height: 30)
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textColor = .black
//        addSubview(label)
    }

    func setTitle(_ title: String) {
        label.text = title
    }

    func setColor(_ color: UIColor) {
        pinTintColor = color
        pinImageView.tintColor = color
    }
}
