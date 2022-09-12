//
//  BannerModel.swift
//  Satluj Network
//
//  Created by eMobx Mac on 23/08/22.
//

import Foundation
class BannerModel:Codable{
    
    var status,title,type,typeContent,coverImage,createdAt,updatedAt,deletedAt:String?
    var id,createdBy:Int?
   
    
    private enum CodingKeys : String, CodingKey {
        case id,status,title,type
        case typeContent = "type_content"
        case coverImage = "cover_image"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "updated_at"
        case createdBy = "created_by"
    }
}

class BannerViewModel{
    var status = ""
    var title = ""
    var type = ""
    var typeContent = ""
    var coverImage = ""
    var createdAt = ""
    var updatedAt = ""
    var deletedAt = ""
    var id = 0
    var createdBy = 0
   
    
    init(model:BannerModel){
        if let value = model.status{
            self.status = value
        }
        if let value = model.title{
            self.title = value
        }
        if let value = model.type{
            self.type = value
        }
        if let value = model.typeContent{
            self.typeContent = value
        }
        if let value = model.coverImage{
            self.coverImage = value
        }
        if let value = model.createdAt{
            self.createdAt = GeneralHelper.shared.UTCToLocal(date: value)
        }
        if let value = model.updatedAt{
            self.updatedAt = value
        }
        if let value = model.deletedAt{
            self.deletedAt = value
        }
        if let value = model.id{
            self.id = value
        }
        if let value = model.createdBy{
            self.createdBy = value
        }
    }
    
    init(model:BannerDBTrending)
    {
        self.status = model.status
        self.title =  model.title
        self.type = model.type
        self.typeContent = model.typeContent
        self.coverImage = model.coverImage
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
        self.deletedAt = model.deletedAt
        self.id = model.id
        self.createdBy = model.createdBy
    }
}
