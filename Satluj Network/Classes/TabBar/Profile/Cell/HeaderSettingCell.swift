//
//  HeaderSettingCell.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit

class HeaderSettingCell: UICollectionViewCell,ProfileConfigureCell {
    typealias Model = ProfileModelSection
    
    //MARK: - Outlet
    @IBOutlet weak var title: UILabel!
    
    //MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setData(model: ProfileModelSection) {
        self.title.text = model.text
    }
    func setSortData(model: SortList) {
        self.title.text = model.desc
    }
    

}
