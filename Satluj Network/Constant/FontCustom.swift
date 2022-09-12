//
//  FontCustom.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import Foundation
import UIKit

struct FontCustom{
    struct Header {
        static let normal = UIFont(name: "OpenSans", size: CGFloat(16))!
    }
    struct Chat {
        static let message = UIFont(name: "OpenSans", size: CGFloat(14))!
    }
    
    struct FontName {
        static let regular = "OpenSans"
        static let semiBold = "OpenSans-Semibold"
        static let bold = "OpenSans-Bold"
    }
    
    static func setFontWith(fontName: String, fontSize: CGFloat)-> UIFont{
        return UIFont.init(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    static func getFontSize(fontSize: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight == 812.0 {return fontSize}
        let newSize = (fontSize/812.0)*screenHeight
        return newSize
    }

}
