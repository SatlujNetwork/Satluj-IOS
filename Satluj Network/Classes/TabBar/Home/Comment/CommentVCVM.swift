//
//  CommentVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 21/04/22.
//

import Foundation
class CommentVCVM{
    
    //MARK: - Variable
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    private (set) var objNews:Bindable<NewsListViewModel?> = Bindable(nil)
    private (set) var arrComments:Bindable<[CommentViewModel]> = Bindable([])
    private (set) var selectedIndex:Bindable<Int> = Bindable(0)
    
    
    //MARK: - init
    init(model:NewsListViewModel?) {
        self.objNews.value = model
    }
    init() {
    }
    
    func limit(isRefresh: Bool) -> Int {
        //If users count = 1 but a new request comes then on refersh send limit not users count
        if isRefresh {
            return arrComments.value.count
        }
        return 0
    }
    
    
   //MARK: - Function
    func updateFlagStatus(){
        let model = arrComments.value[selectedIndex.value]
        if model.is_flag == "no"{
            model.is_flag = "yes"
        }else{
            model.is_flag = "no"
        }
        arrComments.value[selectedIndex.value] = model
    }
    func deleteComment(){
        arrComments.value.remove(at:selectedIndex.value)
    }
    
    
    
    func getCommentList(isInfiniteScroll:Bool,completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        guard let news = self.objNews.value else{return}
        if APIClient.isInternetConnectionAvailable() {
            if !isInfiniteScroll{
                isLoading.value = true
            }
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["news_id"] = "\(news.id)"
            apiData["post_value"] = limit(isRefresh:isInfiniteScroll)
            
            APIClient.getCommentList(params: apiData) { [weak self] result in
                guard let `self` = self else{return}
                self.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            if isInfiniteScroll{
                                let vm = self.arrComments.value
                                self.arrComments.value = data.map({CommentViewModel(model: $0)}) + vm
                            }else{
                                self.arrComments.value = data.map({CommentViewModel(model: $0)})
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
    
    func addComment(comment:String,completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        guard let news = self.objNews.value else{return}
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["news_id"] = "\(news.id)"
            apiData["comment"] = comment
            
            APIClient.addComment(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            self?.arrComments.value.append(CommentViewModel(model: data))
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
    func commentFlagReport(id:String,status:String,completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["id"] = id
            apiData["flag_status"] = status == "no" ? "yes":"no"
            
            APIClient.flagComment(params: apiData) { [weak self] result in
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
    
    func commentDelete(id:String,completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["id"] = id
            APIClient.deleteComment(params: apiData) { [weak self] result in
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
    func commentSpam(id:String,completion:@escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["id"] = id
            apiData["spam_status"] = "yes"
            APIClient.reportComment(params: apiData) { [weak self] result in
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
