//
//  HomeVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import Foundation


class HomeVCVM
{
    //MARK: - Variable
    private (set) var mapCategory:Bindable<[CategoryViewModel]> = Bindable([])
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    private (set) var arrcategoryTitle:Bindable<[String]> = Bindable([])
    private (set) var isLeft:Bindable<Bool> = Bindable(false)
    private (set) var isClose:Bindable<Bool> = Bindable(false)
    var url = ""
    let realm = RealmHelper.getRealm()
    
    

    //MARK: - Function
    func createTitle(){
        arrcategoryTitle.value = mapCategory.value.map({$0.name})
    }
    
    
 
    func fetchCategory(){
        if let categgory = self.realm.objects(CategoryList.self).first{
            mapCategory.value = categgory.list.toSwiftArray(element: CategoryDB.self).map({CategoryViewModel(model: $0)})
            self.createTitle()
        }
    }
    
   
    
   
    
   
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
                        if var data = apiResult.data{
                            let exploreObject = CategoryModel()
                            exploreObject.name = "Explore"
                            data.insert(exploreObject, at: 0)
                            let categoryModel = CategoryList(fromDictionary: data)
                           
                            self?.addCategoryToRealm(model: categoryModel)
                            //self?.categoryList.mapCategory.value =     (self?.categoryList.mapCategory.value.sorted(by: { $0.id < $1.id }))!
                            self?.mapCategory.value = data.map { CategoryViewModel.init(model: $0) }
                            self?.createTitle()
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
    
   
    
    func getLiveNewsLink(completion:@escaping(String?)->Void){
        // Check network avilability before calling API.
         if APIClient.isInternetConnectionAvailable() {
             var apiData = APIParams()
             apiData[APIParameters.registerUser.loginToken] = AuthToken.get()
             APIClient.getLink(params: apiData) {[weak self]  result in
                 guard let `self` = self else{return}
                 switch result{
                 case .success(let apiResult):
                     if apiResult.status == APIResponseStatus.statusCode200
                     {
                         if let data = apiResult.data{
                             self.isClose.value = data.btnposition == "close" ? true:false
                             self.isLeft.value = data.btnposition == "left" ? true:false
                             
                             self.url = data.liveurl
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
     }
    
    func addCategoryToRealm(model:CategoryList){
        try! self.realm.safeWrite {
            self.realm.delete(self.realm.objects(CategoryList.self))
            self.realm.delete(self.realm.objects(NewsDBPopular.self))
            self.realm.delete(self.realm.objects(NewsDBTrending.self))
            self.realm.delete(self.realm.objects(NewsList.self))
            self.realm.delete(self.realm.objects(CategoryDB.self))
            self.realm.add(model)
        }
    }
    
    
}


