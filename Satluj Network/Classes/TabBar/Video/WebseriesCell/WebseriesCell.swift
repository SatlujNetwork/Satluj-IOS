//
//  WebseriesCell.swift
//  Satluj Network
//
//  Created by Mac on 14/07/22.
//

import UIKit

class WebseriesCell: UICollectionViewCell {
    
    @IBOutlet weak var webSeriesImg: CustomImage!
    @IBOutlet weak var webSeriesLabel: UILabel!
    @IBOutlet weak var timeLbl: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webSeriesImg.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        // Initialization code
    }
    
    func setData(model:WebseriesViewModel){
        self.webSeriesLabel.text = model.name + " - Season \(model.season)"
        if let url = URL(string: API.ImageUrl.image + model.thumbNail){
            webSeriesImg.loadImage(key: url.lastPathComponent, urlStr: url)
        }
        else
        {
            webSeriesImg.image = UIImage(named: "dummy")
        }
        timeLbl.setTitle(model.createdAt, for: .normal)
        
    }

}
