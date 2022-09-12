//
//  ProfileVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import Foundation
import UIKit

class ProfileVCVM{
    
    //MARK: - Variable
    private (set) var arrProfile:Box<[ProfileModelSection]> = Box([])
    var vm = SIgnInViewModel()
    //MARK: - constructor
    init() {
       
    }
    
    
    
    //MARK: - Function
    func createProfileModel(){
        guard let userData = UserProfileCache.get() else {return}
        self.vm = SIgnInViewModel(model: userData)
        arrProfile.value =  [ProfileModelSection(image: vm.pic , text: vm.name, type: .profile, items: self.createBasicSetting()),ProfileModelSection(image: "", text: Profile.header, type: .header, items: self.createAdvanceSetting())]
    }
    
    func createBasicSetting()->[ProfileModelItem]{
        var arrBasicSetting = [ProfileModelItem]()
        for data in ProfileBasic.items{
            if data.type == .none{
                arrBasicSetting.append(ProfileModelItem(image: data.image, text: vm.email, type: data.type))
            }else{
                arrBasicSetting.append(ProfileModelItem(image: data.image, text: data.value, type: data.type))
            }
        }
        return arrBasicSetting
    }
    
    
    func createAdvanceSetting()->[ProfileModelItem]{
        var advanceSetting = [ProfileModelItem]()
        for data in ProfileAdvance.items{
            advanceSetting.append(ProfileModelItem(image: data.image, text: data.value, type: data.type))
        }
        return advanceSetting
    }
    
    
    
}



