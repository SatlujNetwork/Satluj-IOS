//
//  Realm.swift
//  ShopNest
//
//  Created by Borovennikov Nikolay on 25.10.2017.
//  Copyright © 2017 Zity Media Inc. All rights reserved.
//

import RealmSwift
import SDWebImage
import UIKit

class RealmHelper {
    
    #if (arch(i386) || arch(x86_64))
    private static var pathPrinted = false
    #endif

    class func getRealm() -> Realm {
        var config:Realm.Configuration? = nil
      
        #if (arch(i386) || arch(x86_64))
            if !RealmHelper.pathPrinted {
                if let urlPath = config?.fileURL!.deletingLastPathComponent().relativePath {
                    debugPrint("Path to Realm files: " + urlPath)
                }
                RealmHelper.pathPrinted = true
            }
        #endif
        var realm: Realm? = nil
        do {
            config = Realm.Configuration.defaultConfiguration
            realm = try Realm(configuration: config!)
        } catch let error as NSError {
            print(error)
            config = Realm.Configuration(
                schemaVersion : 1 
            )
            realm = try! Realm(configuration: config!)
        }
        
        return realm!
    }

    static func writeToRealm(_ action: (_ realm: Realm) -> Void) {
        let realm = self.getRealm()
        if realm.isInWriteTransaction {
            action(realm)
        }
        else {
            try! realm.write {
                action(realm)
            }
        }
    }
    
   
}
