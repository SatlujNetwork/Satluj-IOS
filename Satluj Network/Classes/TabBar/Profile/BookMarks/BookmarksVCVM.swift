//
//  BookmarksVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 21/04/22.
//

import Foundation
class BookmarksVCVM{
     
    //MARK: - Variable
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    private (set) var arrBookmark:Bindable<[BookMarkViewModel]> = Bindable([])
    private (set) var hasData:Bindable<Bool> = Bindable(false)
    
    //MARK: - Function
    func limit(isRefresh: Bool) -> Int {
        //If users count = 1 but a new request comes then on refersh send limit not users count
        if isRefresh {
            return arrBookmark.value.count
        }
        return 0
    }
    
    
    func getBookmarkList(isScroll:Bool,completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["post_value"] = limit(isRefresh:isScroll)
            
            APIClient.getBookMarkList(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            if isScroll{
                                self?.arrBookmark.value += data.map({BookMarkViewModel(model: $0)})
                            }else{
                                self?.arrBookmark.value = data.map({BookMarkViewModel(model: $0)})
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
