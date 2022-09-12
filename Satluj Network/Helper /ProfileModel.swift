//
//  ProfileModelSection.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import Foundation
import UIKit

protocol ProfileConfigureCell{
    associatedtype Model
    func setData(model:Model)
}


//Struct Section
struct ProfileModelSection{
    //MARK: - Variable
    var image:String
    var text:String
    var type:ProfileModelType
    var items = [ProfileModelItem]()
    
    init(image:String,text:String,type:ProfileModelType,items:[ProfileModelItem]){
        self.image = image
        self.text = text
        self.type = type
        self.items = items
    }
    
}

enum ProfileModelType{
    case profile
    case header
}


//Struct Items
struct ProfileModelItem{
    //MARK: - Variable
    var image:UIImage?
    var text:String
    var type:ProfileModelItemType
    
    init(image:UIImage?,text:String,type:ProfileModelItemType){
        self.image = image
        self.text = text
        self.type = type
    }
    
}
enum ProfileModelItemType{
    case forward
    case button
    case none
}



struct ProfileBasic{
    let value:String
    let type:ProfileModelItemType
    let image:UIImage
    
    static var items:[ProfileBasic]{
        return  [ProfileBasic(value: "", type: .none,image: UIImage(named: "email")!),ProfileBasic(value: Profile.editProfile, type: .forward,image: UIImage(named: "editProfile")!),ProfileBasic(value: Profile.logout, type: .forward,image: UIImage(named: "logout")!)
        ]
    }
}

struct ProfileAdvance{
    let value:String
    let type:ProfileModelItemType
    let image:UIImage
    
    static var items:[ProfileAdvance]{
        return [ProfileAdvance(value: Profile.bookmark, type: .forward,image: UIImage(named: "bookmark")!),ProfileAdvance(value: Profile.contactUs, type: .forward,image: UIImage(named: "contactUs")!),ProfileAdvance(value: Profile.privacyPolicy, type: .forward,image: UIImage(named: "privacyPolicy")!),ProfileAdvance(value: Profile.aboutUs, type: .forward,image: UIImage(named: "aboutUs")!)])
        ]
    }
}

