//
//  CategoriesListVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 20/04/22.
//

import Foundation
class CategoriesListVCVM{
    
    //MARK: - Variable
    private (set) var objCategory:Bindable<CategoryViewModel?> = Bindable(nil)
    private (set) var arrcategoryList:Bindable<[NewsListViewModel]> = Bindable([])
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    private (set) var hasData:Bindable<Bool> = Bindable(false)
    
    
    //MARK: - init
    init() {
    }
    
    init(model:CategoryViewModel){
        self.objCategory.value = model
    }
    
    
    
    func limit(isRefresh: Bool) -> Int {
        //If users count = 1 but a new request comes then on refersh send limit not users count
        if isRefresh {
            return arrcategoryList.value.count
        }
        return 0
    }
    
    //MARK: - NetWorkCall
    func getPopularNewsListHome(cat_id:Int,isInfiniteScroll:Bool = false, completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["cat_id"] = cat_id
            apiData["post_value"] = limit(isRefresh:isInfiniteScroll)
            
            APIClient.getPopularNewsList(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            if !isInfiniteScroll{
                                self?.arrcategoryList.value = data.map({NewsListViewModel(model: $0)})
                            }else{
                                self?.arrcategoryList.value += data.map({NewsListViewModel(model: $0)})
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
