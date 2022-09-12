//
//  GeneralHelper.swift
//  iRakhwali
//
//  Created by osx on 27/08/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import RealmSwift

class GeneralHelper:NSObject {
    
    // Create a singleton instance
    static let shared = GeneralHelper()
    var isPurchase = false

    
    //MARK: Show alert
 
    func showAlertActionSheet(_ title: String?, _ message: String, _ completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
       // alert.view.tintColor = ColorPalette.borderColor
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    func showAlertActionSheetTheme(_ title: String?, _ message: String, _ completionlight: @escaping () -> Void, _ completionDark: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
       // alert.view.tintColor = ColorPalette.borderColor
        let light = UIAlertAction(title: "Light", style: .default) { _ in
            completionlight()
        }
        let dark = UIAlertAction(title: "Dark", style: .default) { _ in
            completionDark()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(light)
        alert.addAction(dark)
        alert.addAction(cancelAction)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func setUpTabbar(bgColor: UIColor) {
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarAppearance.backgroundColor = bgColor
            tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorPalette.lightColour]
            if UserDefaults.standard.object(forKey: "theme") != nil{
                if UserDefaults.standard.object(forKey: "theme") as? String == "Light"{
                    tabBarItemAppearance.selected.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: ColorPalette.appColour]
                }else{
                    tabBarItemAppearance.selected.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.white]
                }
                
            }else{
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    tabBarItemAppearance.selected.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.white]
                }
                else {
                    tabBarItemAppearance.selected.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: ColorPalette.appColour]
                }
            }
           
            tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func showAlert(_ title: String?, _ message: String, _ completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
//        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
//        }))
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func showAlertLogin(_ title: String?, _ message: String, _ completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
            completion()
        }))
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func setUpNavigation(bgColor: UIColor){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: ColorPalette.textDarkColour]
        appearance.backgroundColor = bgColor
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func commentDate(date:String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let localDate = dateFormatter.date(from: date){
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "dd MMM yyyy"
            let time = dateFormatter.string(from: localDate)
            return  time
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let localDate = dateFormatter.date(from: date)
            {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "dd MMM yyyy"
                let time = dateFormatter.string(from: localDate)
                return  time
            }
        }
        return date
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let localDate = dateFormatter.date(from: date){
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "dd MMM yyyy"
            let time = dateFormatter.string(from: localDate)
            return  time
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let localDate = dateFormatter.date(from: date)
            {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "dd MMM yyyy"
                let time = dateFormatter.string(from: localDate)
                return  time
            }
        }
        return date
    }
    
    func UtcToLocal(date:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let localDate = dateFormatter.date(from: date){
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let time = dateFormatter.string(from: localDate)
            return  time
        }
        return ""
    }
    func UtcToLocalDate(date:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let localDate = dateFormatter.date(from: date){
            return  localDate
        }
        return Date()
    }
    
    
    func localToUTC(dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return ""
    }
}
extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
extension List {
    func toSwiftArray<T>(element: T.Type) -> [T] {
        var array = [T]()
        if count > 0 {
            for i in 0 ..< count {
                if let result = self[i] as? T {
                    array.append(result)
                }
            }
        }
        return array
    }
}
extension Array {
    
    func isValidIndex(index: Int) -> Bool {
        
        if [Int](0..<self.count).contains(index) {
            return true
        }
        return false
    }
    
}
