//
//  NotificationVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 22/04/22.
//

import Foundation
class NotificationVCVM{
    
    //MARK: - Variable
    private (set) var arrNotification:Bindable<[NotificationModelView]> = Bindable([])
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    private (set) var hasData:Bindable<Bool> = Bindable(false)
    
    //MARK: - Function
    func limit(isRefresh: Bool) -> Int {
        //If users count = 1 but a new request comes then on refersh send limit not users count
        if isRefresh {
            return arrNotification.value.count
        }
        return 0
    }
    
    
    func getNotificationList(isScroll:Bool,completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["post_value"] = limit(isRefresh:isScroll)
            
            APIClient.getNotificationList(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            if isScroll{
                                self?.arrNotification.value += data.map({NotificationModelView(model: $0)})
                            }else{
                                self?.arrNotification.value = data.map({NotificationModelView(model: $0)})
                            }
                        }
                        if let hasMore = apiResult.hasMore{
                            self?.hasData.value = hasMore
                        }
                        completion(nil)
                    }
                    else if apiResult.status == APIResponseStatus.statusCode422{
                      
                        completion(apiResult.message)
                    }
                    else if apiResult.status == APIResponseStatus.statusCode700{
                        ScreenTransitions().sesionExpire()
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
