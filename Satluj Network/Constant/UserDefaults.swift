//
//  UserDefaults.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 03/04/22.
//

import Foundation
struct AuthToken {
    
    static let key = "token"
    //set, get & remove auth token
    static func save(_ value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    static func get() -> String {
        if let token = UserDefaults.standard.value(forKey: key) as? String {
            return token
        } else {
            return ""
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    //valid token
    static func isValid() -> Bool {
        let token = get()
        if token.isEmpty {
            return false
        }
        return true
    }
    //universal method
    static func set(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}

struct Userid{
    static let key = "user_id"
    //set, get & remove auth token
    static func save(_ value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    static func get() -> String {
        if let token = UserDefaults.standard.value(forKey: key) as? String {
            return token
        } else {
            return ""
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    //valid token
    static func isValid() -> Bool {
        let token = get()
        if token.isEmpty {
            return false
        }
        return true
    }
    //universal method
    static func set(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}

struct GmailDetails {
    static let fbDetails = "gmailDetails"
    static func save(_ value: FacebookModel) {
         UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: fbDetails)
    }
    static func get() -> FacebookModel! {
        var fbData: FacebookModel!
        if let data = UserDefaults.standard.value(forKey: fbDetails) as? Data {
            fbData = try? PropertyListDecoder().decode(FacebookModel.self, from: data)
            return fbData!
        } else {
            return fbData
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: fbDetails)
    }
}
struct UserProfileCache {
    
    static let key = "userProfileCache"
    
    static func save(_ value: SignIn) {
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    
    static func get() -> SignIn? {
        
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            
            let userData = try? PropertyListDecoder().decode(SignIn.self, from: data)
            return userData
        } else {
            return nil
        }
    }
   static func remove() {
       
       UserDefaults.standard.removeObject(forKey: key)
   }
   
  
  
//    static func updateUserData(model:ProfileData){
//
//        if let userObject = UserProfileCache.get() {
//            if let name = model.name {
//                userObject.name = name
//            }
//            if let id = model.Id {
//                userObject.Id = id
//            }
//            if let profilePic = model.profilePic {
//                userObject.profilePic = profilePic
//            }
//            if let aboutMe = model.aboutMe {
//                userObject.aboutMe = aboutMe
//            }
//            if let qbid = model.quickbloxUserId{
//                userObject.quickbloxUserId = qbid
//            }
//            if let images = model.images{
//                userObject.images = images
//            }
//            if let age = model.age{
//                userObject.age = age
//            }
//            if let age = model.birthday{
//                userObject.birthday = age
//            }
//            if let profileCompletness = model.profileCompletness{
//                userObject.profileCompletness = profileCompletness
//            }
//            if let value = model.interestedIn {
//                userObject.interestedIn = value
//            }
//            if let value = model.children {
//                userObject.children = value
//            }
//            if let value = model.gender {
//                userObject.gender = value
//            }
//            if let value = model.weight {
//                userObject.weight = value
//            }
//            if let value = model.height {
//                userObject.height = value
//            }
//            if let value = model.zodiac {
//                userObject.zodiac = value
//            }
//            if let value = model.ethnicity {
//                userObject.ethnicity = value
//            }
//            if let value = model.drinking {
//                userObject.drinking = value
//            }
//            if let value = model.smoking {
//                userObject.smoking = value
//            }
//            if let value = model.drinking {
//                userObject.drinking = value
//            }
//            if let value = model.location {
//                userObject.location = value
//            }
//            if let value = model.likeStatus {
//                userObject.likeStatus = value
//            }
//            if let value = model.job {
//                userObject.job = value
//            }
//            if let value = model.email {
//                userObject.email = value
//            }
//            if let value = model.jobTitle {
//                userObject.jobTitle = value
//            }
//            if let value = model.school {
//                userObject.school = value
//            }
//            if let value = model.phone {
//                userObject.phone = value
//            }
//            if let value = model.createdAt {
//                userObject.createdAt = value
//            }
//            if let value = model.countryCode {
//                userObject.countryCode = value
//            }
//            if let value = model.educationLevel {
//                userObject.educationLevel = value
//            }
//            if let value = model.hobbiesInterest {
//                userObject.hobbiesInterest = value
//            }
//
//            UserProfileCache.save(userObject)
//        }
//    }
   
}
