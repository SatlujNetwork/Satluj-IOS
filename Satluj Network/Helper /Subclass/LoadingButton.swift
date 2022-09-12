//
//  LoadingButton.swift
//  Satluj Network
//
//  Created by Nageswar on 07/04/22.
//

import Foundation
import UIKit

class LoadingButton: UIButton {
    
    var activityIndicator: UIActivityIndicatorView?
    
    @IBInspectable var activityIndicatorColor: UIColor = ColorPalette.white{
        didSet{
            activityIndicator?.color = self.activityIndicatorColor
        }
    }
    
    @IBInspectable var bgColor: UIColor =  .clear {
        didSet{
            self.backgroundColor = self.bgColor
        }
    }
    
    @IBInspectable var fontscaling: Bool =  false {
        didSet{
            if fontscaling {
                guard let font  = self.titleLabel?.font else {return}
                self.titleLabel?.font = UIFont(name: font.fontName, size: font.pointSize.dp )
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundColor = bgColor
        self.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.clipsToBounds = true
    }
    
    func loadIndicator(_ shouldShow: Bool) {
        if shouldShow {
            if (activityIndicator == nil) {
                activityIndicator = createActivityIndicator()
            }
            self.isEnabled = false
            self.alpha = 0.7
            showSpinning()
        } else {
            activityIndicator?.stopAnimating()
            self.isEnabled = true
            self.alpha = 1.0
        }
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator!)
        positionActivityIndicatorInButton()
        activityIndicator?.startAnimating()
    }
    
    private func positionActivityIndicatorInButton() {
        let trailingConstraint = NSLayoutConstraint(item: activityIndicator!,
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .leading,
                                                    multiplier: 1, constant: 20)
        self.addConstraint(trailingConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
}
