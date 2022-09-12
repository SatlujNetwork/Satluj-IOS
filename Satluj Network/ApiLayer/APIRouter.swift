//
//  APIRouter.swift
//  BLMO
//
//  Created by Harry on 11/06/21.
//

import Alamofire
import Foundation
enum ParamType {
    case body
    case query
    case url
}

enum APIRouter: URLRequestConvertible {

    case loginUser(param: Parameters)
    case registerUser(param: Parameters)
    case sentMail(param: Parameters)
    case getLink(param: Parameters)
    case verifyEmail(param: Parameters)
    case forgotPassword(param: Parameters)
    case logOutUser(param: Parameters)
    case deleteUser(param: Parameters)
    case getCategoryListApi(param: Parameters)
    case getSliderData(param: Parameters)
    case getBanner(param: Parameters)
    case getHomeNewsList(param: Parameters)
    case getCommentList(param: Parameters)
    case addCommentList(param: Parameters)
    case getNotificationList(param: Parameters)
    case commentDelete(param: Parameters)
    case commentFlag(param: Parameters)
    case commentreport(param: Parameters)
    case likeNews(param: Parameters)
    case bookMark(param: Parameters)
    case getBookmarklist(param: Parameters)
    case userProfile(param: Parameters)
    case socialLogin(param: Parameters)
    case getNewsDetail(param: Parameters)
    case getSearchList(param: Parameters)
    case getVideoWebSeries(param: Parameters)
    case getWebServiceDetail(param: Parameters)
    case getPurchase(param: Parameters)
    case updatePurchaseProduct(param: Parameters)
    


    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .loginUser:
            return .post
        case .registerUser:
            return .post
        case .sentMail:
            return .post
        case .verifyEmail:
            return .post
        case .getLink:
            return .post
        case .forgotPassword:
            return .post
        case .logOutUser:
            return .post
        case .deleteUser:
            return .post
        case .getCategoryListApi:
            return .post
        case .getSliderData:
            return .post
        case .getHomeNewsList:
            return .post
        case .getCommentList:
            return .post
        case .addCommentList:
            return .post
        case .getNotificationList:
            return .post
        case .commentDelete:
            return .post
        case .commentFlag:
            return .post
        case .commentreport:
            return .post
        case .likeNews:
            return .post
        case .userProfile:
            return .post
        case .socialLogin:
            return .post
        case .getNewsDetail:
            return .post
        case .bookMark:
            return .post
        case .getBookmarklist:
            return .post
        case .getSearchList:
            return .post
        case .getVideoWebSeries:
            return .post
        case .getWebServiceDetail:
            return .get
        case .getPurchase:
            return .get
        case .updatePurchaseProduct:
            return .post
        case .getBanner:
            return .get
        }
        

    }

    // MARK: - Path
    private var path: String {
        switch self {
        case .loginUser:
            return ApiUrl.login
        case .registerUser:
            return ApiUrl.registerUser
        case .getLink:
            return ApiUrl.liveStreaming
        case .sentMail:
            return ApiUrl.emailVerification
        case .verifyEmail:
            return ApiUrl.verfiyEmail
        case .forgotPassword:
            return ApiUrl.forgotPassword
        case .logOutUser:
            return ApiUrl.logOut
        case .deleteUser:
            return ApiUrl.deleteUser
        case .getCategoryListApi:
            return ApiUrl.categoryList
        case .getSliderData:
            return ApiUrl.sliderNewsList
        case .getHomeNewsList:
            return ApiUrl.newsList
        case .getCommentList:
            return ApiUrl.commentList
        case .addCommentList:
            return ApiUrl.addComment
        case .getNotificationList:
            return ApiUrl.notificationList
        case .commentDelete:
            return ApiUrl.deleteComment
        case .commentFlag:
            return ApiUrl.flagComment
        case .commentreport:
            return ApiUrl.reportComment
        case .likeNews:
            return ApiUrl.likeNews
        case .userProfile:
            return ApiUrl.fetchProfile
        case .socialLogin:
            return ApiUrl.socialLogin
        case .getNewsDetail:
            return ApiUrl.newsDetail
        case .bookMark:
            return ApiUrl.newsBookMark
        case .getBookmarklist:
            return ApiUrl.getBookmark
        case .getSearchList:
            return ApiUrl.getSearchList
        case .getVideoWebSeries:
            return ApiUrl.getVideoWebseriesList
        case .getWebServiceDetail:
            return ApiUrl.getWebseriesDetail
        case .getPurchase:
            return ApiUrl.getPurchase
        case .updatePurchaseProduct:
            return ApiUrl.updatePurchase
        case .getBanner:
            return ApiUrl.getBanner
        }
    }

    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .loginUser(let param):
            return param
        case .getLink(let param):
            return param
        case .registerUser(let param):
            return param
        case .sentMail(let param):
            return param
        case .verifyEmail(let param):
            return param
        case .forgotPassword(let param):
            return param
        case .logOutUser(let param):
            return param
        case .deleteUser(let param):
            return param
        case .getCategoryListApi(let param):
            return param
        case .getSliderData(let param):
            return param
        case .getHomeNewsList(let param):
            return param
        case .getCommentList(let param):
            return param
        case .addCommentList(let param):
            return param
        case .getNotificationList(let param):
            return param
        case .commentDelete(let param):
            return param
        case .commentFlag(let param):
            return param
        case .commentreport(let param):
            return param
        case .likeNews(let param):
            return param
        case .userProfile(let param):
            return param
        case .socialLogin(let param):
            return param
        case .getNewsDetail(let param):
            return param
        case .bookMark(let param):
            return param
        case .getBookmarklist(let param):
            return param
        case .getSearchList(let param):
            return param
        case .getVideoWebSeries(let param):
            return param
        case .getWebServiceDetail(let param):
            return param
        case .getPurchase(let param):
            return param
        case .updatePurchaseProduct(let param):
            return param
        case .getBanner(let param):
            return param
        }
    }

    private var paramType: ParamType {

        if self.method == .post {
            return .body
        } else if self.method == .get {
            return .url
        }
        return .body
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try CONFIG.serverConfig().asURL()
        
        var urlRequest: URLRequest!
        
        let urlPath = url.appendingPathComponent(path)
        if paramType == .url && path == ApiUrl.getWebseriesDetail{
            let params = parameters as! [String:String]
            var editpath = path
            if let seriesId = params.filter({ key, value in
                return key == "series_id"
            }).first{
                editpath += "\(seriesId.value)"
            }
            if let urlQuestionMark = url.appendingPathComponent(editpath).absoluteString.removingPercentEncoding{
                if let urlDetail = URL(string: urlQuestionMark){
                    urlRequest = URLRequest(url: urlDetail)
                }else{
                    urlRequest = URLRequest(url: urlPath)
                }
            }else{
                urlRequest = URLRequest(url: urlPath)
            }
           
            if let logintoken = params.filter({ key, value in
                return key == "login-token"
            }).first{
                urlRequest.addValue(logintoken.value , forHTTPHeaderField: logintoken.key)
            }
        } else if paramType == .url{
            urlRequest = URLRequest(url: urlPath)
            let params = parameters as! [String:String]
            for (key, value) in params {
                urlRequest.addValue(value , forHTTPHeaderField: key)
            }
        }else {
            urlRequest = URLRequest(url: urlPath)
            print(urlPath.absoluteURL)
        }
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.jsonEncode.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        //        let token = AuthToken.get()
        //let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjBjNzUwMWE3MDUzNjY1Njc0YjNlNjQ2IiwibG9naW5faWQiOiIxMTNlYjM2YWQ2YzA4MGYiLCJpYXQiOjE2MjY0MDgyMjksImV4cCI6MTAwMTYyNjQwODIyOX0.QpswlYRhLdoUeSMh57bE8RSWWvTsaJlakbwJEy1o5hA"
        //        if !token.isEmpty {
        //            urlRequest.setValue("bearer \(token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        //            print("------**** TOKEN: \(token)")
        //        }
        // Parameters
        
        if paramType == .body, let parameters = parameters {
            //if no params just return the request
            if parameters.keys.count == 0 { return urlRequest }
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }


    // MARK: - Convert params as Query String
    func paramsAsQueryString(parameters:[String:Any], isIncludeAsBody:Bool) -> String {
        var question = ""
        if !isIncludeAsBody {
            question = "?"
        }
        var params: String = ""
        for (key, value) in parameters {
            if (params.isEmpty) {
                params = params + question + "\(key)" + "=\(value)"
            }
            else {
                params = params + "&\(key)" + "=\(value)"
            }
        }
        params = params.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
      //  printCustom("params:\(params)")
        return params
    }

    /*

     Call this function if we want to send param in URL
     e.g = http://112.196.26.154:3800/v1/api/user/get-likes/1/10/all
     In params set key as "1", "2" the order in which params should append in URL
     */
    func paramsAsUrl(url: URL, params: [String:Any]) -> URL {

        var newUrl = url.absoluteString
        for i in 0..<params.count {

            if let value = params["\(i)"] {
                newUrl.append("/\(value)")
            }
        }
        return URL(string: newUrl) ?? url
    }

    func multiPartRequest(){


    }


}

