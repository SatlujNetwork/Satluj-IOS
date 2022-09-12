//
//  ProfileCell.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit

class ProfileCell: UICollectionViewCell,ProfileConfigureCell {
   
    //MARK: - Outlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var swNotification: UISwitch!
    @IBOutlet weak var imgForward: UIImageView!
    
    
    //MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
        swNotification.isHidden = true
        imgForward.isHidden = true
        // Initialization code
    }

    func setData(model: ProfileModelItem) {
        swNotification.isHidden = true
        imgForward.isHidden = true
        self.imgProfile.image = model.image
        self.lblText.text = model.text
        if model.type == .forward{
            imgForward.isHidden = false
        }else if model.type == .button{
            swNotification.isHidden = false
        }
        
    }
    
    
}
