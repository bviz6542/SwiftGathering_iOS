//
//  AlertBuilder.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

import UIKit

@objcMembers class AlertBuilder: NSObject {
    private var titleText: String? = nil
    private var messageText: String? = nil
    private var proceedAction: UIAlertAction? = nil
    private var cancelAction: UIAlertAction? = nil
    private var alertPreferredStyle: UIAlertController.Style = .alert
    
    func setTitle(_ titleText: String) -> AlertBuilder {
        self.titleText = titleText
        return self
    }
    
    func setMessage(_ messageText: String) -> AlertBuilder {
        self.messageText = messageText
        return self
    }
    
    func setAlertPreferredStyle(_ alertStyle: UIAlertController.Style) -> AlertBuilder {
        self.alertPreferredStyle = alertStyle
        return self
    }
    
    func setProceedAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        self.proceedAction = UIAlertAction(title: title, style: style, handler: handler)
        return self
    }
    
    func setCancelAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        self.cancelAction = UIAlertAction(title: title, style: style, handler: handler)
        return self
    }
    
    func build() -> UIAlertController {
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: alertPreferredStyle)
        if proceedAction == nil && cancelAction == nil {
            alertController.addAction(UIAlertAction(title: "Confirm", style: .default))
            return alertController
        }
        if let cancelAction = cancelAction {
            alertController.addAction(cancelAction)
        }
        if let proceedAction = proceedAction {
            alertController.addAction(proceedAction)
        }
        return alertController
    }
}
