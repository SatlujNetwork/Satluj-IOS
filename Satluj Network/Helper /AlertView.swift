//
//  AlertView.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 03/04/22.
//

import UIKit

class AlertView: UIView
{
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var txtMessage: UILabel!
    
    var actionTaken: (() -> Void)?
    var cancelActionTaken: (() -> Void)?
    
    //MARK: - init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
    
    func addView(on view: UIView, icon: UIImage?, text:String, selectHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
        
        var contains = false
        for subview in view.subviews {
            
            if let _ = subview as? AlertView {
                contains = true
                break
            }
        }
    
        if !contains {
            hide()
            view.addSubview(self)
        }
        
        self.actionTaken = selectHandler
        self.cancelActionTaken = cancelHandler
        
    }
    
    //MARK: - IBAction
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        cancelActionTaken?()
    }
    
    @IBAction func btnOk(_ sender: UIButton)
    {
        actionTaken?()
    }

}
