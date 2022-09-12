//
//  SortView.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit

class SortView: UIView {
    //MARK: - Outlet
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cvSort: UICollectionView!
    
    //MARK: - Varaible
    var delegate : CollectionViewDelegate?
    var dataSource:CollectionViewDataSource<UICollectionViewCell,String>?
    var canleHandler:(()->Void)?
    var isComment = false
    var cellClick:((Int)->Void)?
    var arrCommentOption = [CommentOptionModel]()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("SortView", owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tabGesture.delegate = self
        contentView.addGestureRecognizer(tabGesture)
        addSubview(contentView)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        self.canleHandler?()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
   
    //MARK: - HideShow
    func show() {
        
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
    
    func removeFromView() {
        self.removeFromSuperview()
    }

    //MARK: - AddView
    func addView(on view: UIView,cancelHander: @escaping () -> Void) {
        
        var contains = false
        for subview in view.subviews {
            
            if let _ = subview as? SortView {
                contains = true
                break
            }
        }
    
        if !contains {
            hide()
            view.addSubview(self)
        }
        self.canleHandler = cancelHander
        handleCollectionView()
    }
    
    func updateOption(isFlag:Bool,isSpam:Bool,isMine:Bool){
        arrCommentOption.removeAll()
        arrCommentOption.append(CommentOptionModel(title: isFlag ? "Unflag this comment":"Flag this comment", img: UIImage(named: "flag")))
        arrCommentOption.append(CommentOptionModel(title: "Report", img: UIImage(named: "report")))
        if isMine{
            arrCommentOption.append(CommentOptionModel(title: "Delete", img: UIImage(named: "delete")))
        }
        self.cvSort.reloadData()
    }
    
    //MARK: - Function
    private func handleCollectionView(){
        cvSort.registerCustom(HeaderSettingCell.self)
        cvSort.registerCustom(CommentReportCell.self)
        delegate = CollectionViewDelegate(didSelectIndex: {[weak self] indexPath in
            self?.cellClick?(indexPath.row)
        }, sizeForItem: { int in
            return CGSize.zero
        })
        
        delegate?.sizeForItem = { section in
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 40)
        }
        
        dataSource = CollectionViewDataSource(cellForIndexPath: {[weak self] indexPath in
            guard let `self` = self else{return UICollectionViewCell()}
            if self.isComment{
                if let cell = self.cvSort.dequeueCell(CommentReportCell.self, indexPath: indexPath){
                    cell.setData(model: self.arrCommentOption[indexPath.row])
                    return cell
                }
            }else{
                if let cell = self.cvSort.dequeueCell(HeaderSettingCell.self, indexPath: indexPath){
                    cell.setSortData(model: SortList.items[indexPath.row])
                    return cell
                }
            }
            
            return UICollectionViewCell()
        }, sections: 1, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            if self.isComment{
                return self.arrCommentOption.count
            }
            return SortList.items.count
        })
        
        cvSort.delegate = delegate
        cvSort.dataSource = dataSource
        cvSort.reloadData()
        
    }
    
    
    
}
struct SortList {
    let desc:String
    static var items:[SortList] {
        return [SortList(desc: "Most Recent"),SortList(desc: "Most Popular")]
    }
}
extension SortView:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.cvSort) == true {
            return false
        }
        return true
    }
}
struct CommentOptionModel{
    var title:String?
    var img:UIImage?
}
