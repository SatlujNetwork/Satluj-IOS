//
//  NewsListLocalDBModel.swift
//  Satluj Network
//
//  Created by Mohit on 08/04/22.
//

import Foundation
import RealmSwift
class CategoryList: Object{
    var list = List<CategoryDB>()
    
    convenience required init(fromDictionary dictionary: [CategoryModel]) {
        self.init()
        for  data in dictionary{
            let newjobs = CategoryDB(fromDictionary:data)
            self.list.append(newjobs)
            
        }
    }
}


class CategoryDB: Object{
    @objc dynamic var id = 0
    @objc dynamic var status = ""
    @objc dynamic var name = ""
    @objc dynamic var coverImage = ""
    @objc dynamic var createdby = 0
    @objc dynamic var createdAt = ""
    @objc dynamic var updatedAt = ""
    @objc dynamic var deletedAt = ""
    
    convenience required init(fromDictionary dictionary: CategoryModel) {
        self.init()
        if let value = dictionary.id{
            self.id = value
        }
        if let value = dictionary.status{
            self.status = value
        }
        if let value = dictionary.name{
            self.name = value
        }
        if let value = dictionary.cover_image{
            self.coverImage = value
        }
        if let value = dictionary.createdby{
            self.createdby = value
        }
        if let value = dictionary.created_at{
            self.createdAt = value
        }
        if let value = dictionary.updated_at{
            self.updatedAt = value
        }
        if let value = dictionary.deleted_at{
            self.deletedAt = value
        }
    }
}


class NewsList: Object{
    @objc dynamic var id = 0
    @objc dynamic var type = ""
    var listTrending = List<BannerDBTrending>()
    var listPopular = List<NewsDBPopular>()
    
    convenience required init(fromDictionary dictionary: [NewsListModel], banner: [BannerModel],type:String,catId:Int) {
        self.init()
        if type == NewsType.trending.rawValue{
            for  data in banner{
                let newjobs = BannerDBTrending(fromDictionary:data)
                self.listTrending.append(newjobs)
            }
        }else{
            for  data in dictionary{
                let newjobs = NewsDBPopular(fromDictionary:data, subCatId: catId)
                self.listPopular.append(newjobs)
            }
        }
        
        self.type = type
        self.id = catId
    }
}

class NewsDBTrending: Object{
    @objc dynamic var id = 0
    @objc dynamic var status = ""
    @objc dynamic var catId = 0
    @objc dynamic var isFeatured = ""
    @objc dynamic var type = ""
    @objc dynamic var contentFile = ""
    @objc dynamic var title = ""
    @objc dynamic var subTitle = ""
    @objc dynamic var coverImage = ""
    @objc dynamic var descr = ""
    @objc dynamic var createdBy = ""
    @objc dynamic var createdAt = ""
    @objc dynamic var updatedAt = ""
    @objc dynamic var deletedAt = ""
    @objc dynamic var isLike = ""
    @objc dynamic var isBookmark = ""
    @objc dynamic var likes = 0
    @objc dynamic var category = ""
    
    
    convenience required init(fromDictionary dictionary: NewsListModel) {
        self.init()
        if let value = dictionary.id{
            self.id = value
        }
        if let value = dictionary.status{
            self.status = value
        }
        if let value = dictionary.cat_id{
            self.catId = value
        }
        if let value = dictionary.is_featured{
            self.isFeatured = value
        }
        if let value = dictionary.type{
            self.type = value
        }
        if let value = dictionary.content_file{
            self.contentFile = value
        }
        if let value = dictionary.title{
            self.title = value
        }
        if let value = dictionary.sub_title{
            self.subTitle = value
        }
        if let value = dictionary.cover_image{
            self.coverImage = value
        }
        if let value = dictionary.description{
            self.descr = value
        }
        if let value = dictionary.is_like{
            self.isLike = value
        }
        if let value = dictionary.is_bookmark{
            self.isBookmark = value
        }
        if let value = dictionary.likes{
            self.likes = value
        }
        if let value = dictionary.category{
            self.category = value
        }
        if let value = dictionary.updated_at{
            self.updatedAt = value
        }
        if let value = dictionary.created_at{
            self.createdAt = value
        }
        if let value = dictionary.deleted_at{
          self.deletedAt = value
        }
//        if let value = dictionary.created_by{
//            self.createdBy = value
//        }
    }
}

class BannerDBTrending: Object{
    
    @objc dynamic var id = 0
    @objc dynamic var status = ""
    @objc dynamic var createdBy = 0
    @objc dynamic var title = ""
    @objc dynamic var type = ""
    @objc dynamic var coverImage = ""
    @objc dynamic var createdAt = ""
    @objc dynamic var updatedAt = ""
    @objc dynamic var deletedAt = ""
    @objc dynamic var typeContent = ""
    
    convenience required init(fromDictionary dictionary: BannerModel) {
        self.init()
        if let value = dictionary.id{
            self.id = value
        }
        if let value = dictionary.status{
            self.status = value
        }
        if let value = dictionary.createdBy{
            self.createdBy = value
        }
        if let value = dictionary.title{
            self.title = value
        }
        if let value = dictionary.type{
            self.type = value
        }
        if let value = dictionary.coverImage{
            self.coverImage = value
        }
        if let value = dictionary.typeContent{
            self.typeContent = value
        }
        if let value = dictionary.updatedAt{
            self.updatedAt = value
        }
        if let value = dictionary.createdAt{
            self.createdAt = value
        }
        if let value = dictionary.deletedAt{
          self.deletedAt = value
        }
    }
}


class NewsDBPopular: Object{
    @objc dynamic var id = 0
    @objc dynamic var status = ""
    @objc dynamic var catId = 0
    @objc dynamic var subCatId = 0
    @objc dynamic var isFeatured = ""
    @objc dynamic var type = ""
    @objc dynamic var contentFile = ""
    @objc dynamic var title = ""
    @objc dynamic var subTitle = ""
    @objc dynamic var coverImage = ""
    @objc dynamic var descr = ""
    @objc dynamic var createdBy = ""
    @objc dynamic var createdAt = ""
    @objc dynamic var updatedAt = ""
    @objc dynamic var deletedAt = ""
    @objc dynamic var isLike = ""
    @objc dynamic var isBookmark = ""
    @objc dynamic var likes = 0
    @objc dynamic var category = ""
    
    
    convenience required init(fromDictionary dictionary: NewsListModel,subCatId:Int) {
        self.init()
        if let value = dictionary.id{
            self.id = value
        }
        if let value = dictionary.status{
            self.status = value
        }
        if let value = dictionary.cat_id{
            self.catId = value
        }
        if let value = dictionary.is_featured{
            self.isFeatured = value
        }
        self.subCatId = subCatId
        if let value = dictionary.type{
            self.type = value
        }
        if let value = dictionary.content_file{
            self.contentFile = value
        }
        if let value = dictionary.title{
            self.title = value
        }
        if let value = dictionary.sub_title{
            self.subTitle = value
        }
        if let value = dictionary.cover_image{
            self.coverImage = value
        }
        if let value = dictionary.description{
            self.descr = value
        }
        if let value = dictionary.is_like{
            self.isLike = value
        }
        if let value = dictionary.is_bookmark{
            self.isBookmark = value
        }
        if let value = dictionary.likes{
            self.likes = value
        }
        if let value = dictionary.category{
            self.category = value
        }
        if let value = dictionary.updated_at{
            self.updatedAt = value
        }
        if let value = dictionary.created_at{
            self.createdAt = value
        }
        if let value = dictionary.deleted_at{
          self.deletedAt = value
        }
//        if let value = dictionary.created_by{
//            self.createdBy = value
//        }
    }
}

enum NewsType:String{
    case trending = "trending"
    case popular = "popular"
}
