//
//  APIClient.swift
//  BLMO
//
//  Created by Harry on 11/06/21.
//

import Alamofire
import Foundation

class APIClient {

    // MARK: - API Request
    @discardableResult
    private static func performRequest< T: Decodable >(route: APIRouter, decoder: JSONDecoder = JSONDecoder(), completion : @escaping  (AFResult<T>) -> Void) -> DataRequest {
        return AF.request(route).debugLog().responseDecodableObject(completionHandler: { ( response: AFDataResponse<T> ) in

            print( response.response?.statusCode as Any )
            print(response.result)

            completion(response.result)

        }).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):

                if let data = value as? NSDictionary {
                    if data["error_code"] as? String == "700"
                    {
                    }
                } else {

                }
                print(response)
            case .failure(_):

                print("Error : \(response.result)")

            }
            print(response)
        }).cURLDescription { description in
            print(description)
        }
    }




    // MARK: - API Cancel Requests
    static func cancelAllRequests() {
        let sessionManager = Alamofire.Session.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
//    static func cancelMyRequest(requestUrl: String) {
//        let url = URL(string: CONFIG.serverConfig())
//        let urlRequest = URLRequest(url: (url?.appendingPathComponent(requestUrl))!)
//        let sessionManager = Alamofire.Session.default
//        sessionManager.session.getTasksWithCompletionHandler { dataTasks, _, _ in
//            dataTasks.forEach {
//                if ($0.originalRequest?.url == urlRequest.url) {
//                    $0.cancel()
//                }
//            }
//        }
//    }
    static func login(params: Parameters, completion:@escaping (AFResult<ServerResponse<SignIn>>) -> Void){
        performRequest(route: APIRouter.loginUser(param: params), completion: completion)
    }

    static func registerUser(params: Parameters, completion:@escaping (AFResult<ServerResponse<SignIn>>) -> Void){
        performRequest(route: APIRouter.registerUser(param: params), completion: completion)
    }
    static func sentMail(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
        performRequest(route: APIRouter.sentMail(param: params), completion: completion)
    }
    static func verifyEmail(params: Parameters, completion:@escaping (AFResult<ServerResponse<SignIn>>) -> Void){
        performRequest(route: APIRouter.verifyEmail(param: params), completion: completion)
    }
    static func forgotPassword(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
        performRequest(route: APIRouter.forgotPassword(param: params), completion: completion)
    }
    
    static func getCategorys(params: Parameters, completion:@escaping (AFResult<ServerResponse<[CategoryModel]>>) -> Void){
        performRequest(route: APIRouter.getCategoryListApi(param: params), completion: completion)
    }
    static func getSliderNewsList(params: Parameters, completion:@escaping (AFResult<ServerResponse<[NewsListModel]>>) -> Void){
        performRequest(route: APIRouter.getSliderData(param: params), completion: completion)
    }
    static func getVideoWebserviceList(params: Parameters, completion:@escaping (AFResult<ServerResponse<VideoModel>>) -> Void){
        performRequest(route: APIRouter.getVideoWebSeries(param: params), completion: completion)
    }
    
    static func getPopularNewsList(params: Parameters, completion:@escaping (AFResult<ServerResponse<[NewsListModel]>>) -> Void){
        performRequest(route: APIRouter.getHomeNewsList(param: params), completion: completion)
    }
    
    static func logoutUser(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
        performRequest(route: APIRouter.logOutUser(param: params), completion: completion)
    }
    static func deleteUser(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
        performRequest(route: APIRouter.deleteUser(param: params), completion: completion)
    }
    
    static func getNewsDetail(params: Parameters, completion:@escaping (AFResult<ServerResponse<NewsListModel>>) -> Void){
        performRequest(route: APIRouter.getNewsDetail(param: params), completion: completion)
    }
    static func getBanner(params: Parameters, completion:@escaping (AFResult<ServerResponse<[BannerModel]>>) -> Void){
        performRequest(route: APIRouter.getBanner(param: params), completion: completion)
    }
    
    
    static func addComment(params: Parameters, completion:@escaping (AFResult<ServerResponse<CommentModel>>) -> Void){
           performRequest(route: APIRouter.addCommentList(param: params), completion: completion)
       }
       
       static func getCommentList(params: Parameters, completion:@escaping (AFResult<ServerResponse<[CommentModel]>>) -> Void){
           performRequest(route: APIRouter.getCommentList(param: params), completion: completion)
       }
       
       
       static func getNotificationList(params: Parameters, completion:@escaping (AFResult<ServerResponse<[NotificationModel]>>) -> Void){
           performRequest(route: APIRouter.getNotificationList(param: params), completion: completion)
       }
       
       static func deleteComment(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
           performRequest(route: APIRouter.commentDelete(param: params), completion: completion)
       }
       static func flagComment(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
           performRequest(route: APIRouter.commentFlag(param: params), completion: completion)
       }
       
       static func reportComment(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
           performRequest(route: APIRouter.commentreport(param: params), completion: completion)
       }
       static func likeButtonNews(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
           performRequest(route: APIRouter.likeNews(param: params), completion: completion)
       }
    static func bookMarkNews(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
        performRequest(route: APIRouter.bookMark(param: params), completion: completion)
    }
    static func getBookMarkList(params: Parameters, completion:@escaping (AFResult<ServerResponse<[BookmarkModel]>>) -> Void){
        performRequest(route: APIRouter.getBookmarklist(param: params), completion: completion)
    }
       
       static func fectUserProfile(params: Parameters, completion:@escaping (AFResult<ServerResponse<SignIn>>) -> Void){
           performRequest(route: APIRouter.userProfile(param: params), completion: completion)
       }
       
       static func socialLogin(params: Parameters, completion:@escaping (AFResult<ServerResponse<SignIn>>) -> Void){
           performRequest(route: APIRouter.socialLogin(param: params), completion: completion)
       }
       
    static func getLink(params: Parameters, completion:@escaping (AFResult<ServerResponse<LiveNews>>) -> Void){
        performRequest(route: APIRouter.getLink(param: params), completion: completion)
    }
    
    static func getSearchResult(params: Parameters, completion:@escaping (AFResult<ServerResponse<[NewsListModel]>>) -> Void){
        performRequest(route: APIRouter.getSearchList(param: params), completion: completion)
    }
    
    static func getWebSeriesDetail(params: Parameters, completion:@escaping (AFResult<ServerResponse<WebseriesDetailModel>>) -> Void){
        performRequest(route: APIRouter.getWebServiceDetail(param: params), completion: completion)
    }
    static func getPurchaseProduct(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
        performRequest(route: APIRouter.getPurchase(param: params), completion: completion)
    }
    
    static func updatePurchaseProduct(params: Parameters, completion:@escaping (AFResult<ServerResponse<ResponseData>>) -> Void){
        performRequest(route: APIRouter.updatePurchaseProduct(param: params), completion: completion)
    }
    
    
    
    // MARK: - Check Internet Connection
    class func isInternetConnectionAvailable() -> Bool {
        let isNetworkAvailable = NetworkReachabilityManager()!.isReachable
        return isNetworkAvailable
    }
}
