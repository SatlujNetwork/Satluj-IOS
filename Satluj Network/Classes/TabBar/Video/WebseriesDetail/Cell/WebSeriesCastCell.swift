//
//  WebSeriesCastCell.swift
//  Satluj Network
//
//  Created by Mac on 18/07/22.
//

import UIKit

class WebSeriesCastCell: UICollectionViewCell {

    //MARK: - Outlet
    @IBOutlet weak var imgCast: CustomImage!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewGradient: UIView!
    
    private var gradient: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradient = CAGradientLayer()
        gradient.frame = viewGradient.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradient.locations = [0, 0.0, 0.5, 1]
        viewGradient.layer.addSublayer(gradient)
        // Initialization code
    }
    
    override func layoutSubviews() {
        gradient.frame = viewGradient.bounds
    }
    
    func setData(model:CastMembersViewModel){
        if let url = URL(string: API.ImageUrl.image + model.pic){
            imgCast.loadImage(key: url.lastPathComponent, urlStr: url)
        }
        self.lblName.text = model.name
    }

}
