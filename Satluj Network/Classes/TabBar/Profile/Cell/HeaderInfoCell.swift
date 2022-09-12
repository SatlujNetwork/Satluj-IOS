//
//  HeaderInfoCell.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit

class HeaderInfoCell: UICollectionViewCell,ProfileConfigureCell {
   
    typealias Model = ProfileModelSection
   
    //MARK: - Outlet
    @IBOutlet weak var imgUser: CustomImage!
    @IBOutlet weak var lblName: UILabel!
    
    
    //MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(model: ProfileModelSection) {
        if let url = URL(string:API.ImageUrl.image + model.image){
            imgUser.loadImage(key: url.lastPathComponent, urlStr: url,isProfile: true)
        }
        else
        {
            imgUser.image = UIImage(named: "download")
        }
        self.lblName.text = model.text
    }
    

    

}
