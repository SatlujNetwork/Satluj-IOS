//
//  HomePhotoCell.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit

class HomePhotoCell: UICollectionViewCell {

    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var newsImg: CustomImage!
    @IBOutlet weak var newsDescLbl: UILabel!
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var timeLbl: UIButton!
    
    private var gradient: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradient = CAGradientLayer()
        gradient.frame = viewGradient.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradient.locations = [0, 0.0, 0.5, 1]
        viewGradient.layer.addSublayer(gradient)
            
    }
    override func layoutSubviews() {
        gradient.frame = viewGradient.bounds
    }
    
    func setData(values:BannerViewModel){
        categoryTitle.text = ""
        newsDescLbl.text = values.title
        timeLbl.setTitle(values.createdAt, for: .normal)
        
        if let url = URL(string: values.coverImage){
            newsImg.loadImage(key: url.lastPathComponent, urlStr: url)
        }
        else
        {
            newsImg.image = UIImage(named: "dummy")
        }
        
        
    }
    
    
}
