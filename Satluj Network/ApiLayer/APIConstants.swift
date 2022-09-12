//
//  APIConstants.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 02/04/22.
//

import Foundation

public typealias APIParams = Dictionary<String, Any>

struct API {
    struct Server {
        static let developmentURL = "http://news.apollow.com/api"
        static let stagingURL = "https://satlujnetwork.com/api"
        static let productionURL = "https://satlujnetwork.com/api"
    }
    struct ImageUrl {
        static let image = "http://satlujnetwork.com"
    }
}

struct APIParameters {
    struct Login {
        static let email = "email"
        static let password = "password"
        static let deviceType = "device_type"
        static let deviceToken = "device_token"
    }
    struct registerUser {
        static let name = "name"
        static let id = "id"
        static let username = "username"
        static let email = "email"
        static let loginToken = "login_token"
        static let otp = "otp"
        static let image = "image"
        static let password = "password"
        static let deviceType = "device_type"
        static let deviceToken = "device_token"
        static let address = "address"
    }
    struct SocialLogin {
        static let email = "email"
        static let deviceType = "device_type"
        static let deviceToken = "device_token"
        static let language = "language"
        static let socialId = "social_id"
        static let type = "type"
        static let pic = "pic"
        static let name = "name"
    }
}
struct ApiUrl {
    static let login = "login"
    static let updateProfile = "user_info_edit"
    static let socialLogin = "social_login"
    static let registerUser = "register_newUser"
    static let forgotPassword = "forget_password"
    static let editUser = "user_info_edit"
    static let fetchProfile = "user_profile"
    static let logOut = "logout"
    static let deleteUser = "user_delete"
    static let newsList = "news_list_view"
    static let sliderNewsList = "news_slider_view"
    static let newsDetail = "news_single_view"
    static let commentList = "comments_specific_news_view"
    static let notificationList = "notification_list"
    static let notificationTop = "notification_top_1"
    static let contentNotificationList = "content_notification_list"
    static let categoryList = "category_list"
    static let mobileVerification = "otp_verification_phone"
    static let emailVerification = "otp_send_to_mail"
    static let verfiyEmail = "otp_verification_email"
    static let addComment = "comments_add"
    static let likeNews = "push_like"
    static let newsBookMark = "push_bookmark"
    static let deleteComment = "comment_is_delete"
    static let flagComment = "comment_is_flag"
    static let reportComment = "comment_is_spam"
    static let liveStreaming = "live_streaming"
    static let getBookmark = "bookmark_list_view"
    static let getSearchList = "news_list_search"
    static let getVideoWebseriesList = "news_list_view_both"
    static let getWebseriesDetail = "getEpisodesOfWebSeries?series_id="
    static let getPurchase = "list_PaymentDetails"
    static let updatePurchase = "store_PaymentDetails"
    static let getBanner = "get_banner"
    
}
struct HTTPErrorCodes {
    static let code404 = 404
    static let code410 = 410
    static let code401 = 401
    
}
struct APIResponseStatus {
    static let statusCode200 = "200"
    static let statusCode401 = "401"
    static let statusCode400 = "400"
    static let statusCode404 = "404"
    static let statusCode406 = "406"
    static let statusCode409 = "409"
    static let statusCode422 = "422"
    static let statusCode425 = "425"
    static let statusCode500 = "500"
    static let statusCode700 = "700"
}
enum HTTPHeaderField: String {
    case accessToken = "x-access-token"
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}
enum ContentType: String {
    case json = "application/json"
    case jsonEncode = "application/json; charset=utf-8"
}
