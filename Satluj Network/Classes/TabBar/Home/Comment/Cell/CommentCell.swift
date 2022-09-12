//
//  CommentCell.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit

class CommentCell: UICollectionViewCell {

    @IBOutlet weak var imgUser: CustomImage!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(values:CommentViewModel){
        self.lblComment.text = values.comment
        self.lblDate.text = values.created_at
        if let user = values.get_user{
            if let url = URL(string: API.ImageUrl.image + user.pic){
                imgUser.loadImage(key: url.lastPathComponent, urlStr: url,isProfile: true)
            }
            else
            {
                imgUser.image = UIImage(named: "download")
            }
        }
       
    }

}
