//
//  ViewAllVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 11/05/22.
//

import Foundation

class ViewAllVCVM{
    
    //MARK: - Variable
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    private (set) var mapNewspopularList:Bindable<[NewsListViewModel]> = Bindable([])
    private (set) var hasData:Bindable<Bool> = Bindable(false)
    
    
    //MARK: - Function
    func limit(isRefresh: Bool) -> Int {
        //If users count = 1 but a new request comes then on refersh send limit not users count
        if isRefresh {
            return mapNewspopularList.value.count
        }
        return 0
    }
    
    func getPopularNewsListHome(isLoadMore:Bool = false, completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["post_value"] = limit(isRefresh:isLoadMore)
            
            APIClient.getPopularNewsList(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            if isLoadMore{
                                self?.mapNewspopularList.value += data.map({NewsListViewModel(model: $0)})
                            }else{
                                self?.mapNewspopularList.value = data.map({NewsListViewModel(model: $0)})
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
