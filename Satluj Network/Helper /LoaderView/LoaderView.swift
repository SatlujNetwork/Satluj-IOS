//
//  LoaderView.swift
//  Satluj Network
//
//  Created by Mohit on 12/04/22.
//

import Foundation
import Lottie
import UIKit
public class LoadingOverlay{

    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var bgView = UIView()
    private var animationView: AnimationView?

    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }

    public func showOverlay(view: UIView) {

        bgView.frame = view.frame
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        bgView.addSubview(overlayView)
        bgView.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin,.flexibleHeight, .flexibleWidth]
        overlayView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        overlayView.center = view.center
        overlayView.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin]
        overlayView.backgroundColor = UIColor.clear
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 30
        animationView = .init(name: "progress")
        animationView!.frame = overlayView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 2.0
        overlayView.addSubview(animationView!)
        view.addSubview(bgView)
        animationView!.play()
        

    }

    public func hideOverlayView() {
        animationView?.stop()
        bgView.removeFromSuperview()
    }
}
