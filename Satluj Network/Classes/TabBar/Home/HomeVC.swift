//
//  HomeVC.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit
import SafariServices
import KMPageMenu
import youtube_ios_player_helper
import ScrollableSegmentedControl


class HomeVC: UIViewController {
    
   
    
    //MARK: - Outlet
    @IBOutlet weak var leftLive: NSLayoutConstraint!
    @IBOutlet weak var rightLive: NSLayoutConstraint!
    @IBOutlet weak var leftVideo: NSLayoutConstraint!
    @IBOutlet weak var rightVideo: NSLayoutConstraint!
    @IBOutlet weak var btnLive: UIButton!
    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnCross: UIView!
    
    
    //MARK: - Variable
   
    var viewModel = HomeVCVM()
    var menu:KMPageMenu?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindableUiToView()
        self.getData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menu?.style.normalTitleColor = self.traitCollection.userInterfaceStyle == .dark ? ColorPalette.lightColour : ColorPalette.textDarkColour
        menu?.style.selectedTitleColor = self.traitCollection.userInterfaceStyle == .dark ? ColorPalette.white : ColorPalette.appColour
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !APIClient.isInternetConnectionAvailable(){
            self.viewModel.fetchCategory()
        }
    }
    
    //MARK: - Function
    func bindableUiToView(){
        
        viewModel.arrcategoryTitle.bind { [weak self] arr in
            self?.setPageControll()
        }
        self.viewModel.isLoading.bind { [weak self] status in
            guard let `self` = self else{return}
            if status{
                LoadingOverlay.shared.showOverlay(view: self.getWindow())
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
        self.viewModel.isClose.bind { [weak self] status in
            self?.btnLive.isHidden = status
        }
        self.viewModel.isLeft.bind{ [weak self] status in
            if status{
                self?.leftLive.isActive = true
                self?.rightVideo.isActive = true
                self?.leftVideo.isActive = false
                self?.rightLive.isActive = false
            }else{
                self?.leftLive.isActive = false
                self?.rightVideo.isActive = false
                self?.leftVideo.isActive = true
                self?.rightLive.isActive = true
            }
        }
    }
    
    
    func getData(){
        self.viewModel.getLiveNewsLink {error in
            
        }
        self.viewModel.getMainCategoryList { [weak self] err in
            if let error = err
            {
                self?.showSwiftMessage(message: error)
            }
            else{
                if self?.viewModel.mapCategory.value.count == 0
                {
                    self?.showSwiftMessage(message: "No Category found")
                }
            }
        }
        
    }
   
    
    func setPlayerView(){
        self.player.isHidden = false
        self.btnCross.isHidden = false
        player.delegate = self
        if let youtubeId = self.viewModel.url.youtubeID{
            player.load(withVideoId: youtubeId)
        }
    }
    
    //MARK: - Function
    private func setPageControll(){
        menu = KMPageMenu(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 44), titles: self.viewModel.arrcategoryTitle.value)
        menu?.style.titleFont = UIFont.systemFont(ofSize: 14)
        menu?.style.normalTitleColor = self.traitCollection.userInterfaceStyle == .dark ? ColorPalette.lightColour : ColorPalette.textDarkColour
        menu?.style.selectedTitleColor = self.traitCollection.userInterfaceStyle == .dark ? ColorPalette.white : ColorPalette.appColour
        containerView.addSubview(menu!)
        
        lazy var page: KMPagingViewController = {
            
            let viewControllers: [UIViewController] = self.viewModel.arrcategoryTitle.value.map { [weak self] objtitle in
                let vc = Storyboard.getViewController(identifier: Storyboard.Controller.homelist, storyboard: Storyboard.Name.home) as! HomeListVC
                vc.viewModel = HomeListVCVM(title: objtitle, arrCategory: self?.viewModel.mapCategory.value ?? [])

                return vc
            }
            let p = KMPagingViewController(viewControllers: viewControllers)
            
            p.view.frame = CGRect(x: 0,
                                  y: menu!.frame.maxY,
                                  width: ScreenSize.SCREEN_WIDTH,
                                  height: containerView.bounds.height - menu!.frame.maxY)
            self.addChild(p)
            p.didMove(toParent: self)
            self.containerView.addSubview(p.view)
            
            return p
        }()
        
        menu?.valueChange = { index in
            page.pagingToViewController(at: index)
        }
        menu?.applyIndicatorLineSizeToFit()
        menu?.addTarget(self, action: #selector(menuValueChange(sender:)), for: .valueChanged)
        page.delegate = self
        page.didFinishPagingCallBack = {[weak self] (currentViewController, currentIndex)in
            self?.menu?.setSelectIndex(index: currentIndex, animated: true)
        }
    }
    @objc func menuValueChange(sender: KMPageMenu) {
        print("selectIndex == \(sender.selectIndex)")
    }
    
    
      //MARK: - Action
    @IBAction func btnNotification(_ sender: UIButton){
        if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.notification, storyboard: Storyboard.Name.home) as? NotificationVC{
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnSearch(_ sender: UIButton){
        if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.searchVC, storyboard: Storyboard.Name.home) as? SearchVC{
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnLiveClick(_ sender: UIButton){
        self.setPlayerView()
    }
    @IBAction func btnCross(_ sender: UIButton){
        self.player.isHidden = true
        self.btnCross.isHidden = true
        self.player.stopVideo()
    }

}
extension HomeVC: KMPagingViewControllerDelegate {
    func pagingController(_ pagingController: KMPagingViewController, didFinish currentViewController: UIViewController, currentIndex: Int) {
        print("selectIndex == \(currentIndex)")
//        menu.setSelectIndex(index: currentIndex, animated: true)
    }
}
extension KMPageMenu {
    
    /// 标题自适应宽度
    func applyLabelWidthSizeToFit() {
        var aStyle = self.style
        aStyle.labelWidthType = .sizeToFit(minWidth: 20)
        self.style = aStyle
    }
    /// 标题固定宽度
    func applyLabelWidthFixed() {
        var aStyle = self.style
        aStyle.labelWidthType = .fixed(width: 100)
        self.style = aStyle
    }
    
    /// 横线指示器自适应宽度
    func applyIndicatorLineSizeToFit() {
        var aStyle = self.style
        aStyle.indicatorColor = ColorPalette.appColour
        aStyle.indicatorPendingHorizontal = 8
        aStyle.indicatorStyle = .line(widthType: .sizeToFit(minWidth: 20), position: .bottom((margin: 1, height: 3)))
        self.style = aStyle
    }
    /// 横线指示器固定宽度
    func applyIndicatorLineFixed() {
        var aStyle = self.style
        aStyle.indicatorColor = ColorPalette.appColour
        aStyle.indicatorPendingHorizontal = 8
        aStyle.indicatorStyle = .line(widthType: .fixed(width: 30), position: .bottom((margin: 1, height: 3)))
        self.style = aStyle
    }
    /// 遮罩指示器自适应宽度
    func applyIndicatorCoverSizeToFit() {
        var aStyle = self.style
        aStyle.indicatorColor = UIColor(white: 0.9, alpha: 1)
        aStyle.indicatorPendingHorizontal = 18
        aStyle.indicatorStyle = .cover(widthType: .sizeToFit(minWidth: 20))
        self.style = aStyle
    }
    /// 遮罩指示器固定宽度
    func applyIndicatorCoverFixed() {
        var aStyle = self.style
        aStyle.indicatorColor = UIColor(white: 0.9, alpha: 1)
        aStyle.indicatorPendingHorizontal = 16
        aStyle.indicatorStyle = .cover(widthType: .fixed(width: 50))
        self.style = aStyle
    }
    
    /// 横线指示器在上
    func applyLinePositionTop() {
        var aStyle = self.style
        let widthType = aStyle.indicatorStyle.widthType
        aStyle.indicatorColor = .red
        aStyle.indicatorPendingHorizontal = 8
        aStyle.indicatorStyle = .line(widthType: widthType, position: .top((margin: 1, height: 2)))
        self.style = aStyle
    }
    /// 横线指示器在下
    func applyLinePositionBottom() {
        var aStyle = self.style
        let widthType = aStyle.indicatorStyle.widthType
        aStyle.indicatorColor = .red
        aStyle.indicatorPendingHorizontal = 8
        aStyle.indicatorStyle = .line(widthType: widthType, position: .bottom((margin: 1, height: 2)))
        self.style = aStyle
    }
}
extension HomeVC: YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        print("Quality :: ", quality)
    }
}
