//
//  ScreenTransition.swift
//  Chumsy
//
//  Created by eMobx Mac on 09/06/21.
//

import UIKit

import SDWebImage

let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate

class ScreenTransitions: NSObject{
 
    
    func moveToWelcomeScreen(){
        // Set welcome screen as root view controller
        let token = AuthToken.get()
        if !token.isEmpty {
            if let user = UserProfileCache.get(){
                if user.emailVerifiedAt != nil{
                    let vc = self.moveTocontroller()

                    if #available(iOS 13.0, *) {
                        if let tabBar = vc as? UITabBarController {
                            SceneDelegate.shared?.window?.rootViewController = tabBar
                        }else if let login = vc as? UINavigationController{
                            SceneDelegate.shared?.window?.rootViewController = login
                        }else{
                            let nav = UINavigationController(rootViewController: vc)
        //                    nav.navigationBar.tintColor = ColorPalette.borderColor
                            SceneDelegate.shared?.window?.rootViewController = nav
                        }
                    }
                    else {
                        if let tabBar = vc as? UITabBarController {
                            sharedAppDelegate.window?.rootViewController = tabBar
                        }else if let login = vc as? UINavigationController{
                            SceneDelegate.shared?.window?.rootViewController = login
                        }
                        else{
                            let nav = UINavigationController(rootViewController: vc)
        //                    nav.navigationBar.tintColor = ColorPalette.borderColor
                            sharedAppDelegate.window?.rootViewController = nav
                        }
                    }
                }
            }
        }
    }
    
    
    func sesionExpire(){
        GeneralHelper.shared.showAlert("", "Session expired! Please login again") {
            self.logout()
        }
        
    }
    func logout(){
        let realm = RealmHelper.getRealm()
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        try! realm.write {
          realm.deleteAll()
        }
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        let welcome = Storyboard.getViewController(identifier: Storyboard.Controller.loginOptions, storyboard: Storyboard.Name.login)
        self.setRootViewController(welcome)
    }
    
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        if #available(iOS 13.0, *) {
            guard let window = SceneDelegate.shared?.window else{return}
            window.rootViewController = vc
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
        else {
            guard let window = sharedAppDelegate.window else{return}
            window.rootViewController = vc
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    func moveTocontroller()-> UIViewController{
        if let userObjc = UserProfileCache.get(){
            let vm = SIgnInViewModel(model: userObjc)
            
            if"\(vm.step)" == nil{
                return Storyboard.getTabBar(identifier: Storyboard.Controller.tabBar, storyboard: Storyboard.Name.tabBar)

            }
            else{
            if "\(vm.step)" == Steps.one{
                return Storyboard.getViewController(identifier: Storyboard.Controller.number, storyboard: Storyboard.Name.login)
            }else if "\(vm.step)" == Steps.two{
                return Storyboard.getViewController(identifier: Storyboard.Controller.dobProfile, storyboard: Storyboard.Name.completeProfile)
            }else if "\(vm.step)" == Steps.three{
                return Storyboard.getViewController(identifier: Storyboard.Controller.AddGenderVC, storyboard: Storyboard.Name.completeProfile)
            }else if "\(vm.step)" == Steps.four{
                return Storyboard.getViewController(identifier: Storyboard.Controller.imageProfile, storyboard: Storyboard.Name.completeProfile)
            }else {
                return Storyboard.getTabBar(identifier: Storyboard.Controller.tabBar, storyboard: Storyboard.Name.tabBar)
            }
                
            }
            
        }
        return Storyboard.getTabBar(identifier: Storyboard.Controller.tabBar, storyboard: Storyboard.Name.tabBar)
//        return Storyboard.getViewController(identifier: Storyboard.Controller.loginOptions, storyboard: Storyboard.Name.login)
    }
  
}
