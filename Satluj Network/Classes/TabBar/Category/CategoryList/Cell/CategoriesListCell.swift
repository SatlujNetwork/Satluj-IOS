//
//  CategoriesListCell.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit

class CategoriesListCell: UICollectionViewCell {

    //MARK: - Outlet
    @IBOutlet weak var imgCategoryList: CustomImage!
    @IBOutlet weak var lblNews: UILabel!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCategoryList.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
       
        // Initialization code
    }
    func setData(type:CellType,model:NewsListViewModel?){
        if type == .video{
            self.btnVideo.isHidden = false
            self.btnVideo.isUserInteractionEnabled = false
        }
        guard let values = model else {return}
        lblNews.text = values.title
        btnTime.setTitle(values.created_at, for: .normal)
        if let url = URL(string:values.cover_image){
            imgCategoryList.loadImage(key: url.lastPathComponent, urlStr: url)
        }
        else
        {
            imgCategoryList.image = UIImage(named: "dummy")
        }
          
        let likecount = values.likes
        if (likecount > 0 && values.is_like == "yes"){
            btnLike.setImage(UIImage.init(named: "likes"), for: .normal)
            btnLike.setTitle("\(likecount)", for: .normal)
        }
        else if (likecount == 0 && values.is_like == "yes") {
            
            btnLike.setImage(UIImage.init(named: "likes"), for: .normal)
            btnLike.setTitle("", for: .normal)
        }
        else if (likecount == 0 && values.is_like == "no") {
            
            btnLike.setImage(UIImage.init(named: "like"), for: .normal)
            btnLike.setTitle("", for: .normal)
        }
    }

}
enum CellType{
    case category
    case video
}
