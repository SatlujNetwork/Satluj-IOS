//
//  CustomSegmentedControl.swif
//
//
//  Created by Bruno Faganello on 05/07/18.
//  Copyright © 2018 Code With Coffe . All rights reserved.
//

import UIKit
protocol CustomSegmentedControlDelegate:NSObject {
    func change(to index:Int)
}

class CustomSegmentedControl: UIView {
    
    //MARK: - Variables
    private var buttonTitles:[String] = []
    private var buttons: [UIButton] = []
    private var selectorView: UIView?
    
    var textColor: UIColor =  UITraitCollection.current.userInterfaceStyle == .dark ? ColorPalette.lightColour : ColorPalette.textDarkColour
    var selectorViewColor: UIColor = ColorPalette.appColour
    var selectorTextColor: UIColor = ColorPalette.appColour
    var font: UIFont? = UIFont(name:FontCustom.FontName.semiBold, size: CGFloat(14.0))
    
    private(set) var selectedIndex: Int = 0
    
    weak var delegate:CustomSegmentedControlDelegate?
    
    //MARK: - Init
    convenience init(frame:CGRect, buttonTitle:[String], color:UIColor? = nil) {
        
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
        
        if let color = color {
            self.textColor = color
        }
        self.backgroundColor = UIColor.white
    }
    
    //MARK: - Draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
     //   self.addShadow(color: ColorPalette.mercuryColor, shadowRadius: 4, shadowOffest: CGSize(width: 0, height: 4))
        updateView()
    }
    
    //MARK: - Functions
    func setButtonTitles(buttonTitles:[String], _ image:[UIImage] ) {
        
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    func setIndex(index:Int) {
        
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView?.frame.origin.x = selectorPosition
        }
    }
    
    func updateTitle(for index: Int, title: String) {
        
        if buttonTitles.isValidIndex(index: index) {
            
            buttonTitles[index] = title
            if buttons.isValidIndex(index: index) {
                buttons[index].setTitle(title, for: .normal)
            }
        }
        
    }
    @objc func buttonAction(sender:UIButton) {
        
        for (buttonIndex, btn) in buttons.enumerated() {
            
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == sender {
                
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView?.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}

//Configuration View
extension CustomSegmentedControl {
    
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func configSelectorView() {
        
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        selectorView?.backgroundColor = selectorViewColor
        addSubview(selectorView!)
    }
    
    private func createButton() {
        
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for i in 0..<buttonTitles.count {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitles[i], for: .normal)
            button.titleLabel?.font = font
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    
}
