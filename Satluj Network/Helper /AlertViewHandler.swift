//
//  AlertViewHandler.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 03/04/22.
//

import Foundation
import UIKit

class AlertViewHandler:NSObject {
    
    // Create a singleton instance
    static let shared = AlertViewHandler()
    var alertView: AlertView?
    var frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    var actionTaken: (() -> Void)?
    var cancelActionTaken: (() -> Void)?

    func setuAlertView()
    {
        alertView = AlertView(frame: frame)
        alertView?.addView(on: SceneDelegate.shared!.window!, icon: nil, text: "", selectHandler: {
            self.actionTaken?()
            self.alertView?.hide()
        }, cancelHandler: {
            self.cancelActionTaken?()
            self.alertView?.hide()
        })
    }
    
    func callAlertView(_ text : String, showCancel: Bool, selectHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void)
    {
        alertView?.viewCancel.isHidden = !showCancel
        alertView?.txtMessage.text = text
        
        self.actionTaken = selectHandler
        self.cancelActionTaken = cancelHandler
        //SceneDelegate.shared!.window!.bringSubviewToFront(alertView!)
        self.alertView?.show()
    }
    
}
