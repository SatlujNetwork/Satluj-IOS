//
//  CategorysVCVM.swift
//  Satluj Network
//
//  Created by Nageswar on 07/04/22.
//

import Foundation

class CategorysVCVM {
    
    //MARK: - Variable
    private (set) var mapCategory:Bindable<[CategoryViewModel]> = Bindable([])
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    let realm = RealmHelper.getRealm()

    //MARK: - Networkcall

    func getMainCategoryList(completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            
            APIClient.getCategorys(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            self?.mapCategory.value = data.map { CategoryViewModel.init(model: $0) }
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
