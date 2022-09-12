//
//  WebserviceModel.swift
//  Satluj Network
//
//  Created by Mac on 14/07/22.
//

import Foundation
class WebseriesModel: Codable {
    var status,name,title,tagLine,releaseYear,isHd,generes,releaseDate,description,castId,creator,thumbNail,videoUrl,director,executiveProducer,music,makeup,directorOfPhotography,createdAt,updatedAt,deletedAt:String?
    var id,noOfParts,parentWebSeriesId,season,getEpisodesCount,getSeasonCount:Int?
    var getTrailer:GetTrailer?
    
    private enum CodingKeys : String, CodingKey {
        case id,status,name,title,generes,description,creator,director,music,makeup,season
        case tagLine = "tag_line"
        case releaseYear = "release_year"
        case isHd = "is_hd"
        case releaseDate = "release_date"
        case castId = "cast_id"
        case thumbNail = "thumb_nail"
        case videoUrl = "video_url"
        case updatedAt = "updated_at"
        case executiveProducer = "executive_producer"
        case directorOfPhotography = "director_of_photography"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case getSeasonCount = "get_season_count"
        case noOfParts = "no_of_parts"
        case parentWebSeriesId = "parent_web_series_id"
        case getEpisodesCount = "get_episodes_count"
        case getTrailer = "get_trailer"
    }

}
class GetTrailer:Codable{
    var id,seriesId,season:Int?
    var name,description,thumbNail,videoUrl,createdAt,updatedAt,deletedAt:String?
    
    private enum CodingKeys : String, CodingKey {
        case id,name,season,description
        case thumbNail = "thumb_nail"
        case videoUrl = "video_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case seriesId = "series_id"
    }
}


class WebseriesViewModel{
    
    var status = ""
    var name = ""
    var title = ""
    var tagLine = ""
    var releaseYear = ""
    var isHd = ""
    var generes = ""
    var releaseDate = ""
    var description = ""
    var castId = ""
    var creator = ""
    var thumbNail = ""
    var videoUrl = ""
    var director = ""
    var executiveProducer = ""
    var music = ""
    var makeup = ""
    var directorOfPhotography = ""
    var createdAt = ""
    var updatedAt = ""
    var deletedAt = ""
    var getSeasonCount = 0
    var id = 0
    var noOfParts = 0
    var parentWebSeriesId = 0
    var season = 0
    var getEpisodesCount = 0
    var getTrailer:GetTrailerViewModel?
    
    init(model:WebseriesModel){
        if let value = model.status{
            self.status = value
        }
        if let value = model.name{
            self.name = value
        }
        if let value = model.title{
            self.title = value
        }
        if let value = model.tagLine{
            self.tagLine = value
        }
        if let value = model.releaseYear{
            self.releaseYear = value
        }
        if let value = model.isHd{
            self.isHd = value
        }
        if let value = model.generes{
            self.generes = value
        }
        if let value = model.releaseDate{
            self.releaseDate = value
        }
        if let value = model.description{
            self.description = value
        }
        if let value = model.castId{
            self.castId = value
        }
        if let value = model.creator{
            self.creator = value
        }
        if let value = model.thumbNail{
            self.thumbNail = value
        }
        if let value = model.videoUrl{
            self.videoUrl = value
        }
        if let value = model.director{
            self.director = value
        }
        if let value = model.executiveProducer{
            self.executiveProducer = value
        }
        if let value = model.music{
            self.music = value
        }
        if let value = model.makeup{
            self.makeup = value
        }
        if let value = model.directorOfPhotography{
            self.directorOfPhotography = value
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
        if let value = model.getSeasonCount{
            self.getSeasonCount = value
        }
        if let value = model.id{
            self.id = value
        }
        if let value = model.noOfParts{
            self.noOfParts = value
        }
        if let value = model.parentWebSeriesId{
            self.parentWebSeriesId = value
        }
        if let value = model.season{
            self.season = value
        }
        if let value = model.getEpisodesCount{
            self.getEpisodesCount = value
        }
        if let value = model.getTrailer{
            self.getTrailer = GetTrailerViewModel(model: value)
        }
        
    }
    
}


class GetTrailerViewModel{
    var id = 0
    var seriesId = 0
    var season = 0
    var name = ""
    var description = ""
    var thumbNail = ""
    var videoUrl = ""
    var createdAt = ""
    var updatedAt = ""
    var deletedAt = ""
    
    init(model:GetTrailer){
        if let value = model.id{
            self.id = value
        }
        if let value = model.seriesId{
            self.seriesId = value
        }
        if let value = model.season{
            self.season = value
        }
        if let value = model.name{
            self.name = value
        }
        if let value = model.description{
            self.description = value
        }
        if let value = model.thumbNail{
            self.thumbNail = value
        }
        if let value = model.videoUrl{
            self.videoUrl = value
        }
        if let value = model.updatedAt{
            self.updatedAt = value
        }
        if let value = model.createdAt{
            self.createdAt = value
        }
        if let value = model.deletedAt{
            self.deletedAt = value
        }
    }
}


class VideoModel:Codable{
    var video:[NewsListModel]?
    var webseries:[WebseriesModel]?
    var hasMoreWebseries,hasMoreVideo:Bool?
    var errorCode,message:String?
    
    private enum CodingKeys : String, CodingKey {
        case video,webseries,message
        case hasMoreWebseries = "has_more_webseries"
        case hasMoreVideo = "has_more_video"
        case errorCode = "error_code"
    }
}
