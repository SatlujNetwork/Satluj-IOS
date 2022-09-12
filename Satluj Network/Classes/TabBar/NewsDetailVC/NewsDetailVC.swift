//
//  NewsDetailVC.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit
import AVKit

class NewsDetailVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var imgNews: CustomImage!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    
    
    //MARK: - Variable
    var viewModel = NewsDetailVCVM()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindebleUI()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        self.navigationController?.navigationBar.setTransparent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.removeTransparent(color: .clear)
    }
    
    //MARK: - Function
    private func bindebleUI(){
        self.viewModel.objNewsDetail.bind { [weak self] objNews in
            if let news = objNews{
                self?.setData(objNews: news)
            }
        }
        self.viewModel.isLoading.bind { [weak self] status in
            guard let `self` = self else{return}
            if status{
                LoadingOverlay.shared.showOverlay(view: self.getWindow())
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    private func getData(){
        self.viewModel.getNewsDetail {  err in
            if let error = err{
                GeneralHelper.shared.showAlert("", error) {}
            }
        }
    }
    
    private func setData(objNews:NewsListViewModel){
        self.btnLike.isSelected = false
        self.btnFav.isSelected = false
        self.btnVideo.isHidden = true
        self.lblTitle.text = objNews.title
        self.lblSubTitle.text = objNews.sub_title
        self.lblDescription.attributedText = objNews.description.htmlToAttributedString
        self.lblCategoryName.text = objNews.categoryName
        self.btnTime.setTitle(objNews.created_at, for: .normal)
        self.btnLikeCount.setTitle("\(objNews.likes) people like this", for: .normal)
        self.btnComment.setTitle(objNews.comments > 1 ? "\(objNews.comments) Comments":"\(objNews.comments) Comment", for: .normal)
        if objNews.type == "video"{
            self.btnVideo.isHidden = false
        }
        if let url = URL(string: API.ImageUrl.image + objNews.cover_image){
            self.imgNews.loadImage(key: url.lastPathComponent, urlStr: url)
        }
        else
        {
            self.imgNews.image = UIImage(named: "dummy")
        }
        if objNews.is_like != "no" && !objNews.is_like.isEmpty{
            self.btnLike.isSelected = true
        }
        if objNews.is_bookmark != "no" && !objNews.is_bookmark.isEmpty{
            self.btnFav.isSelected = true
        }
    }
    
    //MARK: - Action
    @IBAction func btnBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnComment(_ sender: UIButton){
        if AuthToken.isValid(){
            if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.comment, storyboard: Storyboard.Name.home) as? CommentVC{
                vc.hidesBottomBarWhenPushed = true
                vc.viewModel = CommentVCVM(model: self.viewModel.objNewsDetail.value)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            GeneralHelper.shared.showAlertLogin("", "You need to login to access this feature.") {
                ScreenTransitions().logout()
            }
        }
    }
    @IBAction func btnLike(_ sender: UIButton){
        if AuthToken.isValid(){
            self.viewModel.newsLike { err in
                if let error = err{
                    GeneralHelper.shared.showAlert("", error, {})
                }
            }
        }else{
            GeneralHelper.shared.showAlertLogin("", "You need to login to access this feature.") {
                ScreenTransitions().logout()
            }
        }
       
    }
    
    @IBAction func btnBookmark(_ sender: UIButton){
        if AuthToken.isValid(){
            self.viewModel.newsBookmark { err in
                if let error = err{
                    GeneralHelper.shared.showAlert("", error, {})
                }
            }
        }else{
            GeneralHelper.shared.showAlertLogin("", "You need to login to access this feature.") {
                ScreenTransitions().logout()
            }
        }
    }
    @IBAction func btnVideo(_ sender: UIButton){
        guard let model = self.viewModel.objNewsDetail.value else {return}
        guard let videoURL = URL(string: model.content_file) else {return}
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
}
