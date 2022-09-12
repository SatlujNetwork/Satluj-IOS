//
//  ForgotPasswordVCVM.swift
//  Satluj Network
//
//  Created by Nageswar on 07/04/22.
//

import Foundation
class ForgotPasswordVCVM
{
    //MARK: - Variable
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    
    
    //MARK: - Networkcall
    func apiForgotPassword(email:String,completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData[APIParameters.Login.email] = email
           
            APIClient.forgotPassword(params: apiData) { [weak self] result in
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
        else{
            completion(Alert.Error.no_internet_connection)
        }
    }
    
    
}
