//
//  WebseriesDetailModel.swift
//  Satluj Network
//
//  Created by Mac on 14/07/22.
//

import Foundation
class WebseriesDetailModel:Codable{
    var status,name,title,tagLine,releaseYear,isHd,generes,releaseDate,description,castId,creator,thumbNail,videoUrl,director,executiveProducer,music,makeup,directorOfPhotography,createdAt,updatedAt,deletedAt:String?
    var id,noOfParts,parentWebSeriesId,season,getEpisodesCount,getSeasonCount:Int?
    var castMembers:[CastMembers]?
    var lastWatch:LastWatch?
    var getTrailer:GetTrailer?
    var getEpisodes:[LastWatch]?
    var getSeason:[GetSeason]?
    
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
        case castMembers = "cast_members"
        case lastWatch = "last_watch"
        case getTrailer = "get_trailer"
        case getEpisodes = "get_episodes"
        case getSeason = "get_season"
    }
}

class WebseriesDetailViewModel{
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
    var id = 0
    var noOfParts = 0
    var parentWebSeriesId = 0
    var season = 0
    var getEpisodesCount = 0
    var getSeasonCount = 0
    var castMembers:[CastMembersViewModel] = []
    var lastWatch:LastWatchViewModel?
    var getTrailer:GetTrailerViewModel?
    var getEpisodes:[LastWatchViewModel] = []
    var getSeason:[GetSeasonViewModel] = []
    
    init(model:WebseriesDetailModel){
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
            self.createdAt = value
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
        if let value = model.getSeasonCount{
            self.getSeasonCount = value
        }
        if let value = model.castMembers{
            self.castMembers = value.map({CastMembersViewModel(model: $0)})
        }
        if let value = model.lastWatch{
            self.lastWatch = LastWatchViewModel(model: value)
        }
        if let value = model.getTrailer{
            self.getTrailer = GetTrailerViewModel(model: value)
        }
        if let value = model.getEpisodes{
            self.getEpisodes = value.map({LastWatchViewModel(model: $0)})
        }
        if let value = model.getSeason{
            self.getSeason = value.map({GetSeasonViewModel(model: $0)})
        }
    }
}


class CastMembers:Codable{
    var id:Int?
    var name,pic:String?    
}


class CastMembersViewModel{
    var id = 0
    var name = ""
    var pic = ""
    
    init(model:CastMembers){
        if let value = model.id{
            self.id = value
        }
        if let value = model.name{
            self.name = value
        }
        if let value = model.pic{
            self.pic = value
        }
    }
    
}

class LastWatch:Codable{
    var id,seriesId,season,part,videoTime:Int?
    var thumbNail,videoUrl,name,description,createdAt,updatedAt,deletedAt:String?
    var getUserEpisode:GetUserEpisode?
    private enum CodingKeys : String, CodingKey {
        case id,season,name,description,part
        case seriesId = "series_id"
        case thumbNail = "thumb_nail"
        case videoUrl = "video_url"
        case videoTime = "video_time"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case getUserEpisode = "get_user_episode"
    }
    
}

class LastWatchViewModel{
    var id = 0
    var seriesId = 0
    var season = 0
    var thumbNail = ""
    var videoUrl = ""
    var videoTime = 0
    var name = ""
    var description = ""
    var part = 0
    var createdAt = ""
    var updatedAt = ""
    var deletedAt = ""
    var getUserEpisode:GetUserEpisodeViewModel?
    
    init(model:LastWatch){
        if let value = model.id{
            self.id = value
        }
        if let value = model.seriesId{
            self.seriesId = value
        }
        if let value = model.season{
            self.season = value
        }
        if let value = model.thumbNail{
            self.thumbNail = value
        }
        if let value = model.videoUrl{
            self.videoUrl = value
        }
        if let value = model.videoTime{
            self.videoTime = value
        }
        if let value = model.name{
            self.name = value
        }
        if let value = model.description{
            self.description = value
        }
        if let value = model.part{
            self.part = value
        }
        if let value = model.createdAt{
            self.createdAt = value
        }
        if let value = model.deletedAt{
            self.deletedAt = value
        }
        if let value = model.updatedAt{
            self.updatedAt = value
        }
        if let value = model.getUserEpisode{
            self.getUserEpisode = GetUserEpisodeViewModel(model: value)
        }
    }
    
    
}


class GetUserEpisode:Codable{
    var id,episodeId,seriesId,resumeAt,videoTotalTime,userId:Int?
    var createdAt,updatedAt,deletedAt:String?
   
    private enum CodingKeys : String, CodingKey {
        case id
        case episodeId = "episode_id"
        case seriesId = "series_id"
        case resumeAt = "resume_at"
        case videoTotalTime = "video_total_time"
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

class GetUserEpisodeViewModel{
    
    var id = 0
    var episodeId = 0
    var seriesId = 0
    var resumeAt = 0
    var videoTotalTime = 0
    var userId = 0
    var createdAt = ""
    var updatedAt = ""
    var deletedAt = ""
    
    
    init(model:GetUserEpisode){
        if let value = model.id{
            self.id = value
        }
        if let value = model.episodeId{
            self.episodeId = value
        }
        if let value = model.seriesId{
            self.seriesId = value
        }
        if let value = model.resumeAt{
            self.resumeAt = value
        }
        if let value = model.videoTotalTime{
            self.videoTotalTime = value
        }
        if let value = model.userId{
            self.userId = value
        }
        if let value = model.createdAt{
            self.createdAt = value
        }
        if let value = model.updatedAt{
            self.updatedAt = value
        }
        if let value = model.deletedAt{
            self.deletedAt = value
        }
    }
    
}

class GetSeason:Codable{
    var id,noOfParts,parentWebSeriesId,season:Int?
    var status,name,title,tagLine,releaseYear,isHd,generes,releaseDate,description,castId,creator,thumbNail,videoUrl,director,executiveProducer,music,makeup,directorOfPhotography,createdAt,updatedAt,deletedAt:String?
    
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
        case noOfParts = "no_of_parts"
        case parentWebSeriesId = "parent_web_series_id"
    }
    
}



class GetSeasonViewModel{
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
    var id = 0
    var noOfParts = 0
    var parentWebSeriesId = 0
    var season = 0
    
    init(model:GetSeason){
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
            self.createdAt = value
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
        if let value = model.noOfParts{
            self.noOfParts = value
        }
        if let value = model.parentWebSeriesId{
            self.parentWebSeriesId = value
        }
        if let value = model.season{
            self.season = value
        }
        
    }
}
