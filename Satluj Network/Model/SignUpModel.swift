//
//  SignUpModel.swift
//  Satluj Network
//
//  Created by Nageswar on 05/04/22.
//

import Foundation
class SignUpModel: Codable {
    var name,username,email,role,emailVerifiedAt,address,lat,long,phone,phoneVerifiedAt,dateOfBirth,deviceType,deviceToken,gender,pic,language,isSocial,status,timezone,createdAt,updatedAt,userInviteUrl,token,countryCode,phoneCode,isMaster,surname:String?
    var id,step,getMyEventCount,isFriend,isChatBlocked,isMute:Int?
    
    private enum CodingKeys : String, CodingKey {
        case name,username,email,role,phone,gender,pic,language,status,timezone,token,step,id,address,lat,long,surname
        case emailVerifiedAt = "email_verified_at"
        case phoneVerifiedAt = "phone_verified_at"
        case dateOfBirth = "date_of_birth"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case isSocial = "is_social"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userInviteUrl = "user_invite_url"
        case countryCode = "country_code"
        case phoneCode = "phone_code"
        case isMaster = "is_master"
        case isFriend = "is_friend"
        case getMyEventCount = "get_my_event_count"
        case isChatBlocked = "is_chat_blocked"
        case isMute = "is_mute"
    }
}
