//
//  SIgnInViewModel.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 03/04/22.
//

import Foundation
class SIgnInViewModel {
    
    //MARK: Variable
    var name = ""
    var surname = ""
    var username = ""
    var email = ""
    var role = ""
    var emailVerifiedAt = ""
    var phoneVerifiedAt = ""
    var phone = ""
    var dateOfBirth = ""
    var deviceType = ""
    var deviceToken = ""
    var gender = ""
    var pic = ""
    var address = ""
    var lat = ""
    var long = ""
    var language = ""
    var isSocial = ""
    var status = ""
    var timezone = ""
    var createdAt = ""
    var updatedAt = ""
    var userInviteUrl = ""
    var token = ""
    var countryCode = ""
    var phoneCode = ""
    var isMaster = ""
    var id = 0
    var step = 0
    var getMyEventCount = 0
    var isFriend = 0
    var isMute = 0
    var isChatBlocked = 0
    
    //MARK: - init
    init() {
    }
    
    init(model:SignIn) {
        if let value = model.id{
            self.id = value
        }
        if let value = model.surname{
            self.surname = value
        }
        if let value = model.name{
            self.name = value
        }
        if let value = model.username{
            self.username = value
        }
        if let value = model.email{
            self.email = value
        }
        if let value = model.role{
            self.role = value
        }
        if let value = model.emailVerifiedAt{
            self.emailVerifiedAt = value
        }
        if let value = model.address{
            self.address = value
        }
        if let value = model.lat{
            self.lat = value
        }
        if let value = model.long{
            self.long = value
        }
        if let value = model.isMaster{
            self.isMaster = value
        }
        if let value = model.phoneVerifiedAt{
            self.phoneVerifiedAt = value
        }
        if let value = model.phone{
            self.phone = value
        }
        if let value = model.step{
            self.step = value
        }
        if let value = model.dateOfBirth{
            self.dateOfBirth = value
        }
        if let value = model.deviceType{
            self.deviceType = value
        }
        if let value = model.deviceToken{
            self.deviceToken = value
        }
        if let value = model.gender{
            self.gender = value
        }
        if let value = model.pic{
            self.pic = value
        }
        if let value = model.language{
            self.language = value
        }
        if let value = model.isSocial{
            self.isSocial = value
        }
        if let value = model.status{
            self.status = value
        }
        if let value = model.timezone{
            self.timezone = value
        }
        if let value = model.updatedAt{
            self.updatedAt = value
        }
        if let value = model.createdAt{
            self.createdAt = value
        }
        if let value = model.token{
            self.token = value
        }
        if let value = model.userInviteUrl{
            self.userInviteUrl = value
        }
        if let value = model.countryCode{
            self.countryCode = value
        }
        if let value = model.phoneCode{
            self.phoneCode = value
        }
        if let value = model.getMyEventCount{
            self.getMyEventCount = value
        }
        if let value = model.isFriend{
            self.isFriend = value
        }
        if let value = model.isMute{
            self.isMute = value
        }
        if let value = model.isChatBlocked{
            self.isChatBlocked = value
        }
        
    }
    
}
class BadtextViewModel{
    var name = ""
    
    init(model:BadText) {
        if let value = model.name{
            self.name = value
        }
    }
}

