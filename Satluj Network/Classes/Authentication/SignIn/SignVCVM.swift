//
//  SignVCVM.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 02/04/22.
//

import Foundation
class SignVCVM {
    
    //MARK: - Variable
    private (set) var isLoading:Bindable<Bool> = Bindable(false)

    //MARK: - Networkcall
    func apiLogin(email:String,password:String,completion:@escaping(String?)->Void) {
       // Check network avilability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData[APIParameters.Login.email] = email
            apiData[APIParameters.Login.password] = password
            apiData[APIParameters.Login.deviceType] = UniversalText.deviceType
            apiData[APIParameters.Login.deviceToken] = deviceToken

            APIClient.login(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let user = apiResult.data{
                            UserProfileCache.save(user)
                            if let token = user.token{
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
    
    func apiSocialLogin(model:FacebookModel,type:SocialType,completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData[APIParameters.SocialLogin.email] = model.email
            apiData[APIParameters.SocialLogin.deviceType] = UniversalText.deviceType
            apiData[APIParameters.SocialLogin.deviceToken] = UniversalText.deviceToken
            apiData[APIParameters.SocialLogin.name] = model.name
            apiData[APIParameters.SocialLogin.pic] = model.image
            apiData[APIParameters.SocialLogin.socialId] = model.id
            apiData[APIParameters.SocialLogin.type] = type.rawValue
            APIClient.socialLogin(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let user = apiResult.data{
                            if let token = user.token{
                                AuthToken.save(token)
                                Userid.save("\(user.id!)")
                            }
                            UserProfileCache.save(user)
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
        else{
            completion(Alert.Error.no_internet_connection)
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
