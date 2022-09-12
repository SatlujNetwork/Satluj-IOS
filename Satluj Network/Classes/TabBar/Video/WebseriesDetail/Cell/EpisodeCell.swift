//
//  EpisodeCell.swift
//  Satluj Network
//
//  Created by Mac on 18/07/22.
//

import UIKit

class EpisodeCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(model:LastWatchViewModel){
        self.lblTitle.text = "Episode \(model.part)"
        self.lblDescription.text = model.description
    }
}
