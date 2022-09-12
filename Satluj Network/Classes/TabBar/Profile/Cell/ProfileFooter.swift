//
//  ProfileFooter.swift
//  Satluj Network
//
//  Created by Mac on 22/07/22.
//

import UIKit

class ProfileFooter: UICollectionViewCell {

    @IBOutlet weak var btnDeleteAccount: UIButton!
    
    //MARK: - Variable
    var actionDelete:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnDeleteAccount.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        // Initialization code
    }
    
    
    @objc func btnAction(_ sender: UIButton){
        actionDelete?()
    }

}
