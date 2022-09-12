//
//  UiViewControllerExt.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import Foundation
import UIKit
extension UIViewController{
    func getWindow()->UIWindow{
        if #available(iOS 13.0, *) {
           return SceneDelegate.shared!.window!
        }
        else {
            return sharedAppDelegate.window!
        }
    }
    
    func setLeftItemWithBack(_ title: String, andBack back:UIImage, completion: @escaping(Bool)->Void) {
           navigationItem.leftBarButtonItems = nil
           let button = UIButton()
           button.leftImage(image: back)
           button.frame.size.width = 25
           button.frame.size.height = 25
           button.addAction(for: .touchUpInside) { [weak self] in
              completion(true)
           }
           let titleLbl = UILabel()
           titleLbl.text = title
            titleLbl.textColor = ColorPalette.textDarkColour
           titleLbl.font = FontCustom.setFontWith(fontName: FontCustom.FontName.semiBold, fontSize: CGFloat(15.0))
           let titleView = UIStackView(arrangedSubviews: [titleLbl])
           titleView.axis = .horizontal
           titleView.spacing = 0.0
           let leftBarButtonItem = UIBarButtonItem(customView: titleView)
           let leftbackButton = UIBarButtonItem(customView: button)
          navigationItem.leftBarButtonItems = [leftbackButton,leftBarButtonItem]
       }
    func showSwiftMessage(withTitle title:String = "", message: String) {
        
        AlertViewHandler.shared.callAlertView(message, showCancel: false) {
            
        } cancelHandler: {
            
        }
    
}
}
