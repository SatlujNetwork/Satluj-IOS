//
//  UIImageViewEXt.swift
//  Satluj Network
//
//  Created by Mac on 15/07/22.
//

import Foundation
import UIKit

extension UIImageView{
    func applyBlurEffect() {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(blurEffectView)
        }
}
