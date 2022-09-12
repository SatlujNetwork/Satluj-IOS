//
//  DataModel.swift
//  Satluj Network
//
//  Created by Nageswar on 05/04/22.
//

import Foundation

struct signUpModels : Codable {
    let data : SignUpData?
    let error_code : String?
    let message : String?
    let login_token : String?
    let verification_status : Int?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case error_code = "error_code"
        case message = "message"
        case login_token = "login_token"
        case verification_status = "verification_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(SignUpData.self, forKey: .data)
        error_code = try values.decodeIfPresent(String.self, forKey: .error_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        login_token = try values.decodeIfPresent(String.self, forKey: .login_token)
        verification_status = try values.decodeIfPresent(Int.self, forKey: .verification_status)
    }

}
struct SignUpData : Codable {
    let id : String?
    let name : String?
    let username : String?
    let email : String?
    let role : String?
    let email_verified_at : String?
    let password : String?
    let phone_code : String?
    let country_code : String?
    let phone : String?
    let phone_verified_at : String?
    let device_type : String?
    let device_token : String?
    let pic : String?
    let status : String?
    let is_social : String?
    let address : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case role = "role"
        case email_verified_at = "email_verified_at"
        case password = "password"
        case phone_code = "phone_code"
        case phone = "phone"
        case country_code = "country_code"
        case phone_verified_at = "phone_verified_at"
        case device_type = "device_type"
        case device_token = "device_token"
        case pic = "pic"
        case status = "status"
        case is_social = "is_social"
        case address = "address"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        email_verified_at = try values.decodeIfPresent(String.self, forKey: .email_verified_at)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        phone_code = try values.decodeIfPresent(String.self, forKey: .phone_code)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
        phone_verified_at = try values.decodeIfPresent(String.self, forKey: .phone_verified_at)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        pic = try values.decodeIfPresent(String.self, forKey: .pic)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        is_social = try values.decodeIfPresent(String.self, forKey: .is_social)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}


// Main Category List Model
class CategoryModel :Codable
{
    var id: Int?
    var status:String?
    var name:String?
    var cover_image:String?
    var createdby : Int?
    var created_at:String?
    var updated_at:String?
    var deleted_at:String?
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case status = "status"
        case name = "name"
        case cover_image = "cover_image"
        case createdby = "createdby"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case deleted_at = "deleted_at"
        
    }
    
    
}

class CategoryViewModel
{
    var id = 0
    var status = ""
    var name = ""
    var cover_image = ""
    var createdby = 0
    var created_at = ""
    var updated_at = ""
    var deleted_at = ""
    
    init() {
    }
    
    init(model:CategoryModel)
    {
        if let value = model.id{
            self.id = value
        }
        if let value = model.status{
            self.status = value
        }
        if let value = model.name{
            self.name = value
        }
        if let value = model.cover_image{
            self.cover_image = value
        }
        if let value = model.createdby{
            self.createdby = value
        }
        if let value = model.created_at{
            self.created_at = value
        }
        if let value = model.updated_at{
            self.updated_at = value
        }
        if let value = model.deleted_at{
            self.deleted_at = value
        }
        
    }
    
    init(model:CategoryDB)
    {
        self.id = model.id
        self.status = model.status
        self.name = model.name
        self.cover_image = model.coverImage
        self.createdby = model.createdby
        self.created_at = model.createdAt
        self.updated_at = model.updatedAt
        self.deleted_at = model.deletedAt
    }

}
// NewsModel

class NewsListModel :Codable
{
    var id,comments: Int?
    var status:String?
    var cat_id:Int?
    var is_featured:String?
    var type:String?
    var content_file:String?
    var title:String?
    var sub_title:String?
    var cover_image:String?
    var description:String?
   // var created_by : String?
    var created_at:String?
    var updated_at:String?
    var deleted_at:String?
    var is_like:String?
    var is_bookmark:String?
    var likes:Int?
    var category:String?
    var categoryName:String?
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case comments = "comments"
        case status = "status"
        case cat_id = "cat_id"
        case is_featured = "is_featured"
        case type = "type"
        case content_file = "content_file"
        case title = "title"
        case sub_title = "sub_title"
        case description = "description"
        case is_like = "is_like"
        case is_bookmark = "is_bookmark"
        case likes = "likes"
        case category = "category"
        case cover_image = "cover_image"
      //  case created_by = "created_by"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case deleted_at = "deleted_at"
        case categoryName = "category_name"
        
        
    }
    
    
}



class NewsListViewModel
{
    var id = 0
    var status = ""
    var cat_id = 0
    var is_featured = ""
    var type = ""
    var content_file = ""
    var title = ""
    var sub_title = ""
    var cover_image = ""
    var description = ""
    var created_by = ""
    var created_at = ""
    var updated_at = ""
    var deleted_at = ""
    var is_like = ""
    var is_bookmark = ""
    var likes = 0
    var comments = 0
    var category = ""
    var categoryName = ""
    
    
    init() {
    }

    init(model:NewsListModel)
    {
        if let value = model.id{
            self.id = value
        }
        if let value = model.status{
            self.status = value
        }
        if let value = model.comments{
            self.comments = value
        }
        if let value = model.cat_id{
            self.cat_id = value
        }
        if let value = model.categoryName{
            self.categoryName = value
        }
        if let value = model.is_featured{
            self.is_featured = value
        }
        if let value = model.type{
            self.type = value
        }
        if let value = model.content_file{
            self.content_file = value
        }
        if let value = model.title{
            self.title = value
        }
        if let value = model.sub_title{
            self.sub_title = value
        }
        if let value = model.cover_image{
            self.cover_image = value
        }
        if let value = model.description{
            self.description = value
        }
//        if let value = model.created_by{
//            self.created_by = value
//        }
        if let value = model.created_at{
            self.created_at = GeneralHelper.shared.UTCToLocal(date: value)
        }
        if let value = model.updated_at{
            self.updated_at = value
        }
        if let value = model.deleted_at{
            self.deleted_at = value
        }
        if let value = model.category{
            self.category = value
        }
        if let value = model.is_like{
            self.is_like = value
        }
//        if let value = model.created_by{
//            self.created_by = value
//        }
        if let value = model.is_bookmark{
            self.is_bookmark = value
        }
        if let value = model.likes{
            self.likes = value
        }
    }
    
    init(model:NewsDBPopular)
    {
        self.id = model.id
        self.status = model.status
        self.cat_id = model.catId
        self.is_featured = model.isFeatured
        self.type = model.type
        self.content_file = model.contentFile
        self.title = model.title
        self.sub_title = model.subTitle
        self.cover_image = model.coverImage
        self.description = model.descr
        self.created_by = model.createdAt
        self.created_at = GeneralHelper.shared.UTCToLocal(date: model.createdAt)
        self.updated_at = model.updatedAt
        self.deleted_at = model.deletedAt
        self.category = model.category
        self.is_like = model.isLike
        self.created_by = model.createdBy
        self.is_bookmark = model.isBookmark
        self.likes = model.likes
    }
    init(model:NewsDBTrending)
    {
        self.id = model.id
        self.status = model.status
        self.cat_id = model.catId
        self.is_featured = model.isFeatured
        self.type = model.type
        self.content_file = model.contentFile
        self.title = model.title
        self.sub_title = model.subTitle
        self.cover_image = model.coverImage
        self.description = model.descr
        self.created_by = model.createdAt
        self.created_at = GeneralHelper.shared.UTCToLocal(date: model.createdAt)
        self.updated_at = model.updatedAt
        self.deleted_at = model.deletedAt
        self.category = model.category
        self.is_like = model.isLike
        self.created_by = model.createdBy
        self.is_bookmark = model.isBookmark
        self.likes = model.likes
    }
    
    
    
}


class CommentModel :Codable
{
    var id: Int?
    var status:String?
    var is_spam:String?
    var is_flag:String?
    var news_id : Int?
    var comment:String?
    var created_by:Int?
    var created_at:String?
    var updated_at:String?
    var deleted_at:String?
    var get_user:SignIn?
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case status = "status"
        case is_spam = "is_spam"
        case is_flag = "is_flag"
        case news_id = "news_id"
        case comment = "comment"
        case created_by = "created_by"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case deleted_at = "deleted_at"
        case get_user = "get_user"
        
    }
    
    
}

class CommentViewModel
{
    var id = 0
    var status = ""
    var is_spam = ""
    var is_flag = ""
    var news_id = 0
    var comment = ""
    var created_by = 0
    var created_at = ""
    var updated_at = ""
    var deleted_at = ""
    var get_user : SIgnInViewModel?
    
    init() {
    }
    init(model:CommentModel)
    {
        if let value = model.id{
            self.id = value
        }
        if let value = model.status{
            self.status = value
        }
        if let value = model.is_spam{
            self.is_spam = value
        }
        if let value = model.is_flag{
            self.is_flag = value
        }
        if let value = model.news_id{
            self.news_id = value
        }
        if let value = model.comment{
            self.comment = value
        }
        if let value = model.created_by{
            self.created_by = value
        }
        if let value = model.created_at{
            self.created_at = GeneralHelper.shared.commentDate(date: value)
        }
        if let value = model.updated_at{
            self.updated_at = value
        }
        if let value = model.deleted_at{
            self.deleted_at = value
        }
        if let value = model.get_user{
            self.get_user = SIgnInViewModel(model: value)
        }
        
        
    }
    
}


class NotificationModel: Codable
{
    var id: Int?
    var status:String?
    var type:String?
    var cover_image:String?
    var title : String?
    var notice:String?
    var created_by:Int?
    var created_at:String?
    var updated_at:String?
    var deleted_at:String?
    var getNews:NewsListModel?
    
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case status = "status"
        case type = "type"
        case cover_image = "cover_image"
        case title = "title"
        case notice = "notice"
        case created_by = "created_by"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case deleted_at = "deleted_at"
        case getNews = "get_news"
        
    }
    
    
    
}

class NotificationModelView
{
    var id = 0
    var status = ""
    var type = ""
    var cover_image = ""
    var title = ""
    var notice = ""
    var created_by = 0
    var created_at = ""
    var updated_at = ""
    var deleted_at = ""
    var getNews:NewsListViewModel?
    
    
    
    init() {
    }
    init(model:NotificationModel)
    {
        if let value = model.id{
            self.id = value
        }
        if let value = model.status{
            self.status = value
        }
        if let value = model.type{
            self.type = value
        }
        if let value = model.cover_image{
            self.cover_image = value
        }
        if let value = model.title{
            self.title = value
        }
        if let value = model.notice{
            self.notice = value
        }
        if let value = model.created_by{
            self.created_by = value
        }
        if let value = model.created_at{
//            self.created_at = value
            self.created_at = GeneralHelper.shared.UTCToLocal(date: value)
        }
        if let value = model.updated_at{
            self.updated_at = value
        }
        if let value = model.deleted_at{
            self.deleted_at = value
        }
        if let value = model.getNews{
            self.getNews = NewsListViewModel(model: value)
        }
        
    }
    
}

class UserModel : Codable
{
    let id : Int?
    let name : String?
    let username : String?
    let email : String?
    let role : String?
    let email_verified_at : String?
    let password : String?
    let phone_code : String?
    let country_code : String?
    let phone : String?
    let phone_verified_at : String?
    let device_type : String?
    let device_token : String?
    let pic : String?
    let status : String?
    let is_social : String?
    let address : String?
    let created_at : String?
    let updated_at : String?

    private enum CodingKeys : String, CodingKey {
        
        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case role = "role"
        case email_verified_at = "email_verified_at"
        case password = "password"
        case phone_code = "phone_code"
        case phone = "phone"
        case country_code = "country_code"
        case phone_verified_at = "phone_verified_at"
        case device_type = "device_type"
        case device_token = "device_token"
        case pic = "pic"
        case status = "status"
        case is_social = "is_social"
        case address = "address"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    
}

class UserModelView
{
    var id = 0
    var name = ""
    var username = ""
    var email = ""
    var role = ""
    var email_verified_at = ""
    var password = ""
    var phone_code = ""
    var country_code = ""
    var phone = ""
    var phone_verified_at = ""
    var device_type = ""
    var device_token = ""
    var pic = ""
    var status = ""
    var is_social = ""
    var address = ""
    var created_at = ""
    var updated_at = ""
   
    
    init() {
    }
    init(model:UserModel)
    {
        if let value = model.id{
            self.id = value
        }
        if let value = model.name{
            self.name = value
        }
        if let value = model.username{
            self.username = value
        }
        if let value = model.email{
            self.email = value
        }
        if let value = model.role{
            self.role = value
        }
        if let value = model.email_verified_at{
            self.email_verified_at = value
        }
        if let value = model.password{
            self.password = value
        }
       
        if let value = model.phone_code{
            self.phone_code = value
        }
        if let value = model.country_code{
            self.country_code = value
        }
        if let value = model.phone{
            self.phone = value
        }
        if let value = model.phone_verified_at{
            self.phone_verified_at = value
        }
        if let value = model.device_type{
            self.device_type = value
        }
        if let value = model.device_token{
            self.device_token = value
        }
        if let value = model.pic{
            self.pic = value
        }
        if let value = model.status{
            self.status = value
        }
       
        if let value = model.is_social{
            self.is_social = value
        }
        if let value = model.address{
            self.address = value
        }
        if let value = model.created_at{
            self.created_at = GeneralHelper.shared.UTCToLocal(date: value)
        }
        if let value = model.updated_at{
            self.updated_at = value
        }
    }
}

class BookmarkModel:Codable{
    var id,newsId:Int?
    var status,isBookmark,createdAt,updatedAt,deletedAt:String?
    var getNews:NewsListModel?
    
    private enum CodingKeys : String, CodingKey {
        case id,status
        case newsId = "news_id"
        case isBookmark = "is_bookmark"
//        case createdBy = "created_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case getNews = "get_news"
    }
}

class BookMarkViewModel{
    var id = 0
    var newsId = 0
    var status = ""
    var isBookmark = ""
    var createdBy = ""
    var createdAt = ""
    var updatedAt = ""
    var deletedAt = ""
    var getNews:NewsListViewModel?
    
    init(model:BookmarkModel) {
        if let value = model.id{
            self.id = value
        }
        if let value = model.newsId{
            self.newsId = value
        }
        if let value = model.status{
            self.status = value
        }
        if let value = model.isBookmark{
            self.isBookmark = value
        }
        if let value = model.createdAt{
            self.createdAt = GeneralHelper.shared.UTCToLocal(date: value)
        }
//        if let value = model.createdBy{
//            self.createdBy = value
//        }
        if let value = model.updatedAt{
            self.updatedAt = value
        }
        if let value = model.deletedAt{
            self.deletedAt = value
        }
        if let value = model.getNews{
            self.getNews = NewsListViewModel(model: value)
        }
    }
    
}

struct LiveNews : Codable {
    let btnposition : String
    let liveurl : String

}

