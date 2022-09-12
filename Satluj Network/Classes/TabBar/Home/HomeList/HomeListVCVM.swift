//
//  HomeListVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 09/05/22.
//

import Foundation
import RealmSwift

class HomeListVCVM{
    
    //MARK: - Variable
    private (set) var mapNewsList:Bindable<[NewsListViewModel]> = Bindable([])
    private (set) var arrBannerList:Bindable<[BannerViewModel]> = Bindable([])
    private (set) var mapCategory:Bindable<[CategoryViewModel]> = Bindable([])
    private (set) var mapNewspopularList:Bindable<[NewsListViewModel]> = Bindable([])
    private (set) var title:Bindable<String> = Bindable("")
    private (set) var selectedIndex:Bindable<Int> = Bindable(0)
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    let realm = RealmHelper.getRealm()
    
    //MARK: - init
    init(){
        
    }
    init(title:String,arrCategory:[CategoryViewModel]) {
        self.title.value = title
        self.mapCategory.value = arrCategory
        self.getSelectedIndex()
    }
    
    func getSelectedIndex(){
        if let index = mapCategory.value.firstIndex(where: { objCategory in
            return objCategory.name == title.value
        }){
            selectedIndex.value = index
        }
    }
    
    //MARK: - Function
    func fetchNewsFromRealm(catID:Int){
        
        if let objNews = self.realm.objects(NewsList.self).filter({obj in
            return (obj.type == NewsType.trending.rawValue)
        }).first{
            self.arrBannerList.value = objNews.listTrending.toSwiftArray(element: BannerDBTrending.self).map({BannerViewModel(model: $0)})
        }
        if let objPopular = self.realm.objects(NewsList.self).filter({obj in
            return (obj.id == catID) && (obj.type == NewsType.popular.rawValue)
        }).first{
            self.mapNewspopularList.value = objPopular.listPopular.toSwiftArray(element: NewsDBPopular.self).map({NewsListViewModel(model: $0)})
        }else{
            self.mapNewspopularList.value.removeAll()
        }
    }
    func getBanner(completion: @escaping(String?)->Void){
        if APIClient.isInternetConnectionAvailable() {
           // isLoading.value = true
            let apiData = APIParams()
          
            APIClient.getBanner(params: apiData) { [weak self] result in
               // self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            self?.addNewsToRealm(model: [],banner: data, type: .trending, catId: 0)
                            self?.arrBannerList.value = data.map { BannerViewModel.init(model: $0) }
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
    
    
    
    func getMainCategoryList(cat_id:Int,isNextList:Bool = false, completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
           // isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            if cat_id != 0{
                apiData["cat_id"] = cat_id
            }
            
            APIClient.getSliderNewsList(params: apiData) { [weak self] result in
               // self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                          //  self?.viewModel.mapNewsList.value =     (self?.viewModel.mapNewsList.value.sorted(by: { $0.id > $1.id }))!
                            
                            self?.addNewsToRealm(model: data, banner: [], type: .trending, catId: cat_id)
                            self?.mapNewsList.value = data.map { NewsListViewModel.init(model: $0) }
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
    
    func getPopularNewsListHome(cat_id:Int,isNextList:Bool = false, completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            if cat_id != 0{
                apiData["cat_id"] = cat_id
            }
            
            APIClient.getPopularNewsList(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                           // self?.viewModel.mapNewspopularList.value =     (self?.popularnewsListModel.mapNewspopularList.value.sorted(by: { $0.id > $1.id }))!
                            
                            self?.addNewsToRealm(model: data, banner: [], type: .popular, catId: cat_id)
                            if !isNextList{
                                self?.callPopularNewsList(catID: cat_id)
                                self?.mapNewspopularList.value = data.map { NewsListViewModel.init(model: $0) }
                            }
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
    
    func addNewsToRealm(model:[NewsListModel], banner: [BannerModel],type:NewsType,catId:Int){
        try! self.realm.safeWrite {
            if type == .trending{
                let arrNews = self.realm.objects(BannerDBTrending.self)
                for data in arrNews{
                    if model.filter({ objNews in
                        return objNews.id == data.id
                    }).first != nil{
                        self.realm.delete(data)
                    }
                }
            }else{
                let arrNews = self.realm.objects(NewsDBPopular.self)
                for data in arrNews{
                    if model.filter({ objNews in
                        return objNews.id == data.id && data.subCatId == catId
                    }).first != nil{
                        self.realm.delete(data)
                    }
                }
            }
           
            if let list = self.realm.objects(NewsList.self).filter({ obj in
                return (obj.id == catId) && (obj.type == type.rawValue)
            }).first{
                self.realm.delete(list)
            }
            let model = NewsList(fromDictionary: model, banner: banner, type: type.rawValue, catId: catId)
            self.realm.add(model)
        }
    }
    
   
    func callPopularNewsList(catID:Int){
        if let index = self.mapCategory.value.firstIndex(where: { objCategory in
            return objCategory.id == catID
        }){
            if self.mapCategory.value.isValidIndex(index: index+1){
                self.getPopularNewsListHome(cat_id: self.mapCategory.value[index+1].id, isNextList: true) { error in
                }
            }
           
        }
    }
    
    func callTrendgNewsList(catID:Int){
        if let index = self.mapCategory.value.firstIndex(where: { objCategory in
            return objCategory.id == catID
        }){
            if self.mapCategory.value.isValidIndex(index: index+1){
                self.getMainCategoryList(cat_id: self.mapCategory.value[index+1].id, isNextList: true) { error in
                }
            }
           
        }
    }
}
