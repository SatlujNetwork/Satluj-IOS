//
//  SearchVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 22/04/22.
//

import Foundation
class SearchVCVM{
    
    //MARK: - Variable
    private (set) var arrSearch:Bindable<[NewsListViewModel]> = Bindable([])
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    
    //MARK: - Function
    func getSearchList(text:String,completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["search_key"] = text
            
            APIClient.getSearchResult(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            self?.arrSearch.value = data.map({NewsListViewModel(model: $0)})
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
