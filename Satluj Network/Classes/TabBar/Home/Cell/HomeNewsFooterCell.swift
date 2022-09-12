//
//  HomeNewsFooterCell.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit
import AdvancedPageControl

class HomeNewsFooterCell: UICollectionViewCell {

    //MARK: - Outlet
    @IBOutlet var pageControl: AdvancedPageControlView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: 5,
                                                space: 10.0,
                                               indicatorColor: ColorPalette.segmentSelected,
                                               dotsColor: ColorPalette.lightColour,
                                                isBordered: false,
                                                borderWidth: 0.0,
                                                indicatorBorderColor: .clear,
                                                indicatorBorderWidth: 0.0)
        // Initialization code
    }
    
    func setNumberOfpage(count:Int){
        pageControl.drawer.numberOfPages = count
    }
    
    func updateIndicator(index:Int){
        pageControl.setPage(index)
    }

}
