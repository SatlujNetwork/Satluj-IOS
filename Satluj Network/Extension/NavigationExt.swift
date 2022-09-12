//
//  UIViewControllerExt.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import Foundation
import UIKit

extension UINavigationBar {
    func setTransparent() {
        backgroundColor = .clear
        isTranslucent = true
        standardAppearance.shadowColor = .clear
        standardAppearance.backgroundColor = .clear
        standardAppearance.backgroundEffect = nil
        scrollEdgeAppearance = standardAppearance
    }
    func removeTransparent(color:UIColor) {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        backgroundColor = color
        isTranslucent = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        standardAppearance = appearance
        scrollEdgeAppearance = standardAppearance
    }
}
class DarkModeAwareNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.updateBarTintColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateBarTintColor()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateBarTintColor()
    }
    
    private func updateBarTintColor() {
        if #available(iOS 13.0, *) {
            self.navigationBar.barTintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
        }
    }
}
