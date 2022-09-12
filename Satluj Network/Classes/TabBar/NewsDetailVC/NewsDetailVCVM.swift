//
//  NewsDetailVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 20/04/22.
//

import Foundation
class NewsDetailVCVM{
    //MARK: - Variable
    private (set) var objNewsDetail:Bindable<NewsListViewModel?> = Bindable(nil)
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    var newsID = 0
    
    //MARK: - init
    init() {
    }
    
    init(newsId:Int,objNews:NewsListViewModel?) {
        newsID = newsId
        objNewsDetail.value = objNews
    }
    
    func updateLikeStatus(){
        if let objNews = objNewsDetail.value{
            if objNews.is_like == "yes"{
                objNews.is_like = "no"
                objNews.likes -= 1
            }else{
                objNews.is_like = "yes"
                objNews.likes += 1
            }
            objNewsDetail.value = objNews
        }
    }
    func updateBookMarkStatus(){
        if let objNews = objNewsDetail.value{
            if objNews.is_bookmark == "yes"{
                objNews.is_bookmark = "no"
            }else{
                objNews.is_bookmark = "yes"
            }
            objNewsDetail.value = objNews
        }
    }
    
    
    //MARK: - Function
    func getNewsDetail(completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["id"] = newsID
            
            APIClient.getNewsDetail(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            self?.objNewsDetail.value = NewsListViewModel(model: data)
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
    func newsLike(completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["news_id"] = newsID
            
            APIClient.likeButtonNews(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            self?.updateLikeStatus()
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
    func newsBookmark(completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["news_id"] = newsID
            
            APIClient.bookMarkNews(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            self?.updateBookMarkStatus()
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
