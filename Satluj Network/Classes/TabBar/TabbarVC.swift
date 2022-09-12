//
//  TabbarVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit

class TabbarVC: UITabBarController {

    //MARK: - Variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   GeneralHelper.shared.setUpTabbar(bgColor: ColorPalette.navigationBarColour)
        GeneralHelper.shared.setUpNavigation(bgColor: ColorPalette.navigationBarColour)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.delegate = self
        // Do any additional setup after loading the view.
    }
}

extension TabbarVC:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let navigation = viewController as? UINavigationController, let _ = navigation.visibleViewController as? ProfileVC{
            if !AuthToken.isValid(){
                GeneralHelper.shared.showAlertLogin("", "You need to login to access this feature.") {
                    ScreenTransitions().logout()
                }
                return false
            }
        }
        return true
    }
}
