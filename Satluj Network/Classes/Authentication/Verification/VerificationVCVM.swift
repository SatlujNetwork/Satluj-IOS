//
//  VerificationVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 15/04/22.
//

import Foundation
class VerificationVCVM{
    
    //MARK: - Variable
    var email = ""
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    
    //MARK: - init
    init(email:String) {
        self.email = email
    }
    
    init() {
        
    }
    
    //MARK: - Function
    func sendVerifyEmail(completion:@escaping(String?)->Void){
        // Check network avilability before calling API.
         if APIClient.isInternetConnectionAvailable() {
             isLoading.value = true
             var apiData = APIParams()
             apiData[APIParameters.registerUser.email] = email
             apiData[APIParameters.registerUser.loginToken] = AuthToken.get()
             apiData[APIParameters.registerUser.deviceType] = UniversalText.deviceType
             apiData[APIParameters.registerUser.deviceToken] = deviceToken

             APIClient.sentMail(params: apiData) { [weak self] result in
                 self?.isLoading.value = false
                 switch result{
                 case .success(let apiResult):
                     if apiResult.status == APIResponseStatus.statusCode200
                     {
                         completion(nil)
                     }
                     else if apiResult.status == APIResponseStatus.statusCode422{
                       
                         completion(apiResult.message)
                     }
                     else {
                         completion(apiResult.message)
                     }
                 case .failure(let error):
                     completion(error.localizedDescription)
                 }
             }
         }
     }
    
    func verifyEmail(otp:String,completion:@escaping(String?)->Void){
        // Check network avilability before calling API.
         if APIClient.isInternetConnectionAvailable() {
             isLoading.value = true
             var apiData = APIParams()
             apiData[APIParameters.registerUser.email] = email
             apiData[APIParameters.registerUser.otp] = otp
             apiData[APIParameters.registerUser.deviceType] = UniversalText.deviceType
             apiData[APIParameters.registerUser.deviceToken] = deviceToken

             APIClient.verifyEmail(params: apiData) { [weak self] result in
                 self?.isLoading.value = false
                 switch result{
                 case .success(let apiResult):
                     if apiResult.status == APIResponseStatus.statusCode200
                     {
                         if let user = apiResult.data{
                             UserProfileCache.save(user)
                             if let token = user.deviceToken{
                                 AuthToken.save(token)
                             }
                             if let id = user.id{
                                 Userid.save("\(id)")
                             }
                         }
                         if let token = apiResult.loginToken{
                             AuthToken.save(token)
                         }
                         completion(nil)
                     }
                     else if apiResult.status == APIResponseStatus.statusCode422{
                       
                         completion(apiResult.message)
                     }
                     else {
                         completion(apiResult.message)
                     }
                 case .failure(let error):
                     completion(error.localizedDescription)
                 }
             }
         }
     }
    
}
