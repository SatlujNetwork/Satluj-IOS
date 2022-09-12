//
//  BookmarkCell.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit

class BookmarkCell: UICollectionViewCell {
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var newsImg: CustomImage!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnLike.isHidden = false
        // Initialization code
    }
    func setdata(type:BookmarkType,model:BookMarkViewModel?,searchModel:NewsListViewModel? = nil){
        self.btnLike.isHidden = false
        if let objBookmark = model{
            self.timeBtn.setTitle(objBookmark.createdAt, for: .normal)
            if let getNews = objBookmark.getNews{
                if let url = URL(string:getNews.cover_image){
                    newsImg.loadImage(key: url.lastPathComponent, urlStr: url)
                }
                else
                {
                    newsImg.image = UIImage(named: "dummy")
                }
                self.titleLbl.text = getNews.title
                if getNews.is_like == "yes"{
                    btnLike.isSelected = true
                    btnLike.setTitle(" \(getNews.likes)", for: .normal)
                }else{
                    btnLike.isSelected = false
                    btnLike.setTitle(getNews.likes == 0 ? "" : " \(getNews.likes)", for: .normal)
                }
            }
        }
        if let search = searchModel{
            self.timeBtn.setTitle(search.created_at, for: .normal)
                if let url = URL(string:search.cover_image){
                    newsImg.loadImage(key: url.lastPathComponent, urlStr: url)
                }
                else
                {
                    newsImg.image = UIImage(named: "dummy")
                }
                self.titleLbl.text = search.title
                if search.is_like == "yes"{
                    btnLike.isSelected = true
                    btnLike.setTitle(" \(search.likes)", for: .normal)
                }else{
                    btnLike.isSelected = false
                    btnLike.setTitle(search.likes == 0 ? "" : " \(search.likes)", for: .normal)
                }
        }
    }
    
    func setDataNotifification(model:NotificationModelView){
        self.btnLike.isHidden = true
        self.timeBtn.setTitle(model.created_at, for: .normal)
        if let url = URL(string: API.ImageUrl.image + model.cover_image){
                newsImg.loadImage(key: url.lastPathComponent, urlStr: url)
            }
            else
            {
                newsImg.image = UIImage(named: "dummy")
            }
            self.titleLbl.text = model.title
    }
    

}
enum BookmarkType{
    case bookmark
    case notification
}
