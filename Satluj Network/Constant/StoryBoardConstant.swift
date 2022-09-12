//
//  StoryBoardConstant.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import Foundation
import UIKit

struct Storyboard {
    struct Name {
        static let login  = "Main"
        static let tabBar = "Tabbar"
        static let video = "Video"
        static let home = "Home"
        static let profile = "Profile"
        static let categories = "Categories"
        static let completeProfile = "CompleteProfile"


       
    }
    struct Controller {
        static let loginOption  = "LoginNavController"
        static let verify  = "VerificationVC"
        static let editProfile  = "EditProfileVC"
        static let bookmark = "BookmarksVC"
        static let categoryList = "CategoriesListVC"
        static let detailVC = "NewsDetailVC"
        static let notification = "NotificationVC"
        static let homelist = "HomeListVC"
        static let searchVC = "SearchVC"
        static let comment = "CommentVC"
        static let dobProfile = "CompleteProfileDOBVC"
        static let number = "AddPhoneNumberVC"
        static let AddGenderVC = "AddGenderVC"
        static let imageProfile = "UploadImageVC"
        static let loginOptions = "LoginNavController"
        static let tabBar = "TabbarVC"
        static let viewAll = "ViewAllVC"
        static let webseries = "WebserviceVC"




        
   }
    static func getViewController(identifier: String, storyboard: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
    static func getTabBar(identifier: String, storyboard: String) -> UITabBarController {
        let storyBoard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: identifier)
        return viewController as! UITabBarController
    }
}
