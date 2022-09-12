//
//  SignUpVCVM.swift
//  Satluj Network
//
//  Created by Nageswar on 05/04/22.
//

import Foundation
class SignUpVCVM {
    
    
    
    //MARK: - Variable
    private (set) var isLoading:Bindable<Bool> = Bindable(false)

    //MARK: - Networkcall
    func apiRegisteruser(name:String,email:String,password:String,completion:@escaping(String?)->Void) {
       // Check network avilability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData[APIParameters.registerUser.name] = name
            apiData[APIParameters.registerUser.username] = name
            apiData[APIParameters.registerUser.image] = ""
            apiData[APIParameters.registerUser.address] = ""
            apiData[APIParameters.registerUser.email] = email
            apiData[APIParameters.registerUser.password] = password
            apiData[APIParameters.registerUser.deviceType] = UniversalText.deviceType
            apiData[APIParameters.registerUser.deviceToken] = deviceToken

            APIClient.registerUser(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        self?.sendVerifyEmail(email: email, completion: { error in
                        })
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
    
    func sendVerifyEmail(email:String,completion:@escaping(String?)->Void){
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
    
}
