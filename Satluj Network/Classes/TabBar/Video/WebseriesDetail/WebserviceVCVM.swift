//
//  WebserviceVCVM.swift
//  Satluj Network
//
//  Created by Mac on 15/07/22.
//

import Foundation
enum WebseriesSegment{
    case episode
    case moredetail
}



class WebserviceVCVM{
    
    //MARK: - Variable
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    private (set) var objWerseries:Bindable<WebseriesDetailViewModel?> = Bindable(nil)
    private (set) var type:Bindable<WebseriesSegment> = Bindable(.episode)
    private (set) var arrMoreDetail:Bindable<[MoreDetailModel]> = Bindable([])
    private (set) var arrCast:Bindable<[CastMembersViewModel]> = Bindable([])
    var seriesId = ""
    
    //MARK: - init
    init(){
        
    }
    
    init(seriesId:String){
        self.seriesId = seriesId
    }
    
    //MARK: - Function
    func setUpMoredetailView(){
        arrMoreDetail.value.removeAll()
        guard let objSeries = self.objWerseries.value else{
            return
        }
        //setTitle
        arrMoreDetail.value.append(MoreDetailModel(name: MoreDetailText.title, value: objSeries.title, arrImages: nil))
        //Genre
        arrMoreDetail.value.append(MoreDetailModel(name: MoreDetailText.genre, value: objSeries.generes, arrImages: nil))
        //Director
        arrMoreDetail.value.append(MoreDetailModel(name: MoreDetailText.director, value: objSeries.director, arrImages: nil))
        //Producer
        arrMoreDetail.value.append(MoreDetailModel(name: MoreDetailText.producer, value: objSeries.executiveProducer, arrImages: nil))
        //Music
        arrMoreDetail.value.append(MoreDetailModel(name: MoreDetailText.music, value: objSeries.music, arrImages: nil))
        //Makeup
        arrMoreDetail.value.append(MoreDetailModel(name: MoreDetailText.makeUp, value: objSeries.makeup, arrImages: nil))
        //Photography
        arrMoreDetail.value.append(MoreDetailModel(name: MoreDetailText.photography, value: objSeries.directorOfPhotography, arrImages: nil))
       //Cast&Crew
        arrCast.value = objSeries.castMembers
    }
    
    
    
    
    
    //MARK: - Webservice
    func getWebseasonDetail(completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login-token"] = AuthToken.get()
            apiData["series_id"] = self.seriesId
            
            APIClient.getWebSeriesDetail(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            self?.objWerseries.value = WebseriesDetailViewModel(model: data)
                            self?.setUpMoredetailView()
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
    
    func checkPurchased(completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            var apiData = APIParams()
            apiData["login-token"] = AuthToken.get()
            apiData["product_id"] = InAppPurchaseId.purchaseId
           
            APIClient.getPurchaseProduct(params: apiData) { result in
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        if let data = apiResult.data{
                            GeneralHelper.shared.isPurchase = true
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
    
    func updatePurchase(model:PriceModel ,completion: @escaping(String?)->Void){
        // Check network availability before calling API.
        if APIClient.isInternetConnectionAvailable() {
            isLoading.value = true
            var apiData = APIParams()
            apiData["login_token"] = AuthToken.get()
            apiData["payment_status"] = model.status
            apiData["product_id"] = model.productId
            apiData["type"] = "inapp"
            apiData["price_currency_code"] = model.identifier
            apiData["price"] = model.price
            apiData["purchase_token"] = model.token
            
            APIClient.updatePurchaseProduct(params: apiData) { [weak self] result in
                self?.isLoading.value = false
                switch result{
                case .success(let apiResult):
                    if apiResult.status == APIResponseStatus.statusCode200
                    {
                        GeneralHelper.shared.isPurchase = true
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

struct MoreDetailModel{
    let name:String
    let value:String
    let arrImages:[CastMembersViewModel]?
}

struct PriceModel{
    let productId:String
    let price:String
    let identifier:String
    let status:String
    let token:String
}
