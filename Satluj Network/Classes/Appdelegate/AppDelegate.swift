//
//  AppDelegate.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit
import RealmSwift
import SDWebImageWebPCoder
import GoogleSignIn
import SwiftyStoreKit

var deviceToken :String? = "abcder"
let signInConfig = GIDConfiguration.init(clientID: "841220371530-9kmjtfvo5ge6p2cu8c2ogcl8804srr34.apps.googleusercontent.com")

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let realm = RealmHelper.getRealm()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ScreenTransitions().moveToWelcomeScreen()
        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
        let titleSelectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleSelectedTextAttributes, for: .selected)
        let titleNormalTextAttributes = [NSAttributedString.Key.foregroundColor: ColorPalette.appColour]
        UISegmentedControl.appearance().setTitleTextAttributes(titleNormalTextAttributes, for: .normal)
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.productId == InAppPurchaseId.purchaseId{
                        GeneralHelper.shared.isPurchase = true
                    }
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.restorePurchases { result in
            for purchase in result.restoredPurchases {
                if let transtion = purchase.originalTransaction{
                    switch transtion.transactionState {
                    case .purchased, .restored:
                        if purchase.productId == InAppPurchaseId.purchaseId{
                            GeneralHelper.shared.isPurchase = true
                        }
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    }
                }
            }
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Override point for customization after application launch.
        
        //AlertViewHandler.shared.setuAlertView()

        sleep(3)
        return true
    }
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
//    func verifyPurchase(with id: String, sharedSecret: String) {
//            let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: sharedSecret)
//            SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
//                switch result {
//                case .success(let receipt):
//                    let productId = id
//                    // Verify the purchase of Consumable or NonConsumable
//                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
//                        productId: productId,
//                        inReceipt: receipt)
//
//                    switch purchaseResult {
//                    case .purchased(let receiptItem):
//                        print("\(productId) is purchased: \(receiptItem)")
//
//                    case .notPurchased:
//                       print("not purchased")
//                    }
//                case .error(let error):
//                    print("Receipt verification failed: \(error)")
//                }
//            }
//        }
}


