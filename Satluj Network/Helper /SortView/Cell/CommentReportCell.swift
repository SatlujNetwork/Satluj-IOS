//
//  CommentReportCell.swift
//  Satluj Network
//
//  Created by Mohit on 12/05/22.
//

import UIKit

class CommentReportCell: UICollectionViewCell {

    //MARK: - Outlet
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgOption: UIImageView!
    
    //MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(model:CommentOptionModel){
        self.title.text = model.title
        if let img = model.img{
            self.imgOption.image = img
        }
    }
    

}
