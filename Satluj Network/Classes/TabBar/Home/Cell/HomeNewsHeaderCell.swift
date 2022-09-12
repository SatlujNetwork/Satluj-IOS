//
//  HomeNewsHeaderCell.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit

class HomeNewsHeaderCell: UICollectionViewCell {

    @IBOutlet weak var btnViewAll: UIButton!
    
    var btnViewAllClick:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnViewAll.addTarget(self, action: #selector(clickViewAll(sender:)), for: .touchUpInside)
        // Initialization code
    }
    
    @objc func clickViewAll(sender:UIButton){
        btnViewAllClick?()
    }

}
