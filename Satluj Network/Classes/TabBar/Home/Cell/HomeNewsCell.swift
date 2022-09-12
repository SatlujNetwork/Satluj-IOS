//
//  HomeNewsCell.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit

class HomeNewsCell: UICollectionViewCell {
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var newsImg: CustomImage!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpData(values:NewsListViewModel){
        titleLbl.text = values.title
        descriptionLbl.attributedText = values.description.htmlToAttributedString
        timeBtn.setTitle(values.created_at, for: .normal)
        if let url = URL(string:values.cover_image){
            newsImg.loadImage(key: url.lastPathComponent, urlStr: url)
        }
        else
        {
            newsImg.image = UIImage(named: "dummy")
        }
        
        if values.is_like == "yes"{
            likeCountBtn.isSelected = true
            likeCountBtn.setTitle(" \(values.likes)", for: .normal)
        }else{
            likeCountBtn.isSelected = false
            likeCountBtn.setTitle(values.likes == 0 ? "" : " \(values.likes)", for: .normal)
        }
        
        
    }
    
}
