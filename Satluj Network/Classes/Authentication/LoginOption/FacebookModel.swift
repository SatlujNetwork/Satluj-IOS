//
//  FacebookModel.swift
//  Chumsy
//
//  Created by osx on 04/10/21.
//

import Foundation
import GoogleSignIn

class FacebookModel:Codable {
    
    //MARK: - Variable
    var id = ""
    var name = ""
    var surname = ""
    var email = ""
    var image = ""
    
    //MARK: - init
    init() {
    }
    
    init(model:Dictionary<String,Any>) {
        if let socialId = model["id"] as? String{
            self.id = socialId
        }
        if let name = model["name"] as? String{
            self.name = name
        }
        if let surname = model["last_name"] as? String{
            self.surname = surname
        }
        if let email = model["email"] as? String{
            self.email = email
        }else{
            self.email = self.id + "@facebook.com"
        }
        
        
        if let image = model["picture"] as? [String:AnyObject]{
            if let data = image["data"] as? [String : AnyObject]{
                if let imgUrl = data["url"] as? String
                {
                    self.image = imgUrl
                }
            }
        }
    }
    init(model:GIDGoogleUser) {
        if let socialId = model.userID{
            self.id = socialId
        }
        if let profile = model.profile{
            self.name = profile.name
            self.surname = profile.familyName ?? ""
            self.email = profile.email
            if profile.hasImage
            {
                if let pic = profile.imageURL(withDimension: 100)
                {
                    self.image = "\(pic)"
                }
            }
        }
    }
}
