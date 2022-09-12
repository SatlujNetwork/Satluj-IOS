//
//  MoredetailCell.swift
//  Satluj Network
//
//  Created by Mac on 18/07/22.
//

import UIKit

class MoredetailCell: UICollectionViewCell {

    //MARK: - Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(model:MoreDetailModel){
        self.lblTitle.text = model.name
        self.lblDescription.text = model.value
    }
    
    

}
