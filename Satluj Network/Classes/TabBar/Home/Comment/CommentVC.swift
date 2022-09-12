//
//  CommentVC.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit

class CommentVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var cvComment: UICollectionView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var constBottomComment: NSLayoutConstraint!
    
    //MARK: - Variable
    var viewModel = CommentVCVM()
    var refresher = UIRefreshControl()
    var delegete:CollectionViewDelegate?
    var sortView:SortView?
    var dataSource:CollectionViewDataSource<UICollectionViewCell,String>?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindableUI()
       longpress()
        addSortView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        handleCollectionView()
        self.txtComment.setLeftPaddingPoints(15)
        self.setLeftItemWithBack(NavigationTitle.comment, andBack: UIImage(named: "backk")!) { [weak self] status in
            self?.navigationController?.popViewController(animated: true)
        }
        getData(scroll: false)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - Function
    private func longpress(){
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.cvComment.addGestureRecognizer(longPressGR)
    }
    
    @objc func handleLongPress(longPressGR: UILongPressGestureRecognizer) {
        if longPressGR.state != .ended {
            return
        }
        let point = longPressGR.location(in: self.cvComment)
        let indexPath = self.cvComment.indexPathForItem(at: point)
        if let indexPath = indexPath {
            self.viewModel.selectedIndex.value = indexPath.row
            let model = self.viewModel.arrComments.value[indexPath.row]
            if let user = model.get_user{
                sortView?.updateOption(isFlag: model.is_flag == "no" ? false:true, isSpam: model.is_spam == "no" ? false:true, isMine: "\(user.id)" == Userid.get() ? true:false)
            }else{
                sortView?.updateOption(isFlag: model.is_flag == "no" ? false:true, isSpam: model.is_spam == "no" ? false:true, isMine: false)
            }
            sortView?.show()
        }
    }
    
    private func addSortView(){
        sortView = SortView(frame: self.view.frame)
        sortView?.addView(on: self.getWindow(), cancelHander: {[weak self] in
            self?.sortView?.hide()
        })
        sortView?.cellClick = {[weak self] index in
            guard let `self` = self else{return}
            if index == 0{
                self.viewModel.commentFlagReport(id:"\(self.viewModel.arrComments.value[index].id)",status: self.viewModel.arrComments.value[index].is_flag) { [weak self] err in
                    if let error = err{
                        GeneralHelper.shared.showAlert("", error, {})
                    }else{
                        self?.sortView?.hide()
                        self?.viewModel.updateFlagStatus()
                    }
                }
                
            }else if index == 1{
                self.viewModel.commentSpam(id: "\(self.viewModel.arrComments.value[index].id)") { [weak self] err in
                    if let error = err{
                        GeneralHelper.shared.showAlert("", error, {})
                    }else{
                        self?.sortView?.hide()
                    }
                }
                
            }else if index == 2{
                self.viewModel.commentDelete(id: "\(self.viewModel.arrComments.value[index].id)") { [weak self] err in
                    if let error = err{
                        GeneralHelper.shared.showAlert("", error, {})
                    }else{
                        self?.sortView?.hide()
                        self?.viewModel.deleteComment()
                    }
                }
            }
        }
        sortView?.isComment = true
    }
    
    
    private func getData(scroll:Bool){
        self.viewModel.getCommentList(isInfiniteScroll: scroll) {[weak self] err in
            self?.cvComment.refreshControl?.endRefreshing()
            if let error = err{
                GeneralHelper.shared.showAlert("", error, {})
            }
        }
    }
    private func bindableUI(){
        self.viewModel.isLoading.bind { [weak self] status in
            guard let `self` = self else{return}
            if status{
                LoadingOverlay.shared.showOverlay(view: self.getWindow())
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
        self.viewModel.arrComments.bind { [weak self] arr in
            self?.cvComment.reloadData()
        }
    }
    
    
    private func handleCollectionView(){
        cvComment.registerCustom(CommentCell.self)
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        cvComment.refreshControl = refresher
        delegete = CollectionViewDelegate(didSelectIndex: { indexPath in
            
        }, sizeForItem: { section in
            return CGSize.zero
        })
        
        dataSource = CollectionViewDataSource(cellForIndexPath: { [weak self] indexPath in
            guard let `self` = self else{return UICollectionViewCell()}
            if let cell = self.cvComment.dequeueCell(CommentCell.self, indexPath: indexPath){
                let user = self.viewModel.arrComments.value[indexPath.row]
                cell.setData(values: user)
                return cell
            }
            return UICollectionViewCell()
        }, sections: 1, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            return self.viewModel.arrComments.value.count
        })
        
        cvComment.delegate = delegete
        cvComment.dataSource = dataSource
        cvComment.collectionViewLayout = self.createCompositionalLayout()
        cvComment.reloadData()
    }
    @objc func refreshData() {
        self.getData(scroll: true)
    }
    
    //MARK: - CompositionalLayout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return self.createBookmark()
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    
    func createBookmark() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.SCREEN_WIDTH), heightDimension: .estimated(20))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }

    //MARK: - KeyboardNotification
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if #available(iOS 11.0, *) {
                let window = SceneDelegate.shared?.window
                let bottomPadding = window?.safeAreaInsets.bottom
                self.constBottomComment.constant = keyboardSize.height-bottomPadding!
               
            }else{
                self.constBottomComment.constant = keyboardSize.height
                
            }
        }
    }
    
    @objc  func keyboardWillHide(notification: NSNotification) {
        self.constBottomComment.constant = 0
    }
    
    //MARK: - Action
    @IBAction func btnSendComment(_ sender: UIButton){
        guard let comment = self.txtComment.text else{return}
        if comment.isEmpty{
            GeneralHelper.shared.showAlert("", "Please enter comment", {})
        }else{
            self.txtComment.text = ""
            self.viewModel.addComment(comment: comment) { err in
                if let error = err{
                    GeneralHelper.shared.showAlert("", error, {})
                }
            }
        }
    }

}
