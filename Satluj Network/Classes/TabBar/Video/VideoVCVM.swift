//
//  VideoVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 20/04/22.
//

import Foundation
enum VideoType{
    case video
    case webSeries
}


class VideoVCVM{
    
    //MARK: - Variable
    private (set) var arrVideoList:Bindable<[NewsListViewModel]> = Bindable([])
    private (set) var arrWebSeries:Bindable<[WebseriesViewModel]> = Bindable([])
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    private (set) var hasDataVideo:Bindable<Bool> = Bindable(false)
    private (set) var hasDataWebseries:Bindable<Bool> = Bindable(false)
    private (set) var type:Bindable<VideoType> = Bindable(.video)
    
    //MARK: - Function
    func limit(isRefresh: Bool) -> Int {
        //If users count = 1 but a new request comes then on refersh send limit not users count
        if isRefresh {
            return arrVideoList.value.count
        }
        return 0
    }
    
    
    func getVideoList(isInfiniteScroll:Bool = false, completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["post_type"] = "video"
            apiData["post_value"] = limit(isRefresh:isInfiniteScroll)
            
            APIClient.getVideoWebserviceList(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            if !isInfiniteScroll{
                                if let video = data.video{
                                    self?.arrVideoList.value = video.map({NewsListViewModel(model: $0)})
                                }
                                if let webseries = data.webseries{
                                    self?.arrWebSeries.value = webseries.map({WebseriesViewModel(model: $0)})
                                }
                            }else{
                                if let video = data.video{
                                    self?.arrVideoList.value += video.map({NewsListViewModel(model: $0)})
                                }
                                if let webseries = data.webseries{
                                    self?.arrWebSeries.value += webseries.map({WebseriesViewModel(model: $0)})
                                }
                            }
                            if let hasMore = data.hasMoreVideo{
                                self?.hasDataVideo.value = hasMore
                            }
                            if let hasMore = data.hasMoreWebseries{
                                self?.hasDataWebseries.value = hasMore
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
    
    
}
