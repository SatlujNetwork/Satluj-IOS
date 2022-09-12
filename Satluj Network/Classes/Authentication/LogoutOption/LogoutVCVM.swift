//
//  LogoutVCVM.swift
//  Satluj Network
//
//  Created by Nageswar on 07/04/22.
//

import Foundation

class LogoutVCVM
{
    //MARK: - Variable
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    
    
    //MARK: - Networkcall
    func apiLogoutClicked(completion: @escaping(String?,Bool)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
           
            APIClient.logoutUser(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                         
                        completion(nil,false)
                    }
                    else if apiResult.status == APIResponseStatus.statusCode422{
                      
                        completion(apiResult.message,true)
                    }
                    else {
                        completion(apiResult.message,false)
                    }
                case .failure(let error):
                    completion(error.localizedDescription,false)
                }
            }
        }
        else{
            completion(Alert.Error.no_internet_connection,false)
        }
    }
    func apiDelete(completion: @escaping(String?,Bool)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
           
            APIClient.deleteUser(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                         
                        completion(nil,false)
                    }
                    else if apiResult.status == APIResponseStatus.statusCode422{
                      
                        completion(apiResult.message,true)
                    }
                    else {
                        completion(apiResult.message,false)
                    }
                case .failure(let error):
                    completion(error.localizedDescription,false)
                }
            }
        }
        else{
            completion(Alert.Error.no_internet_connection,false)
        }
    }
    
    
}
