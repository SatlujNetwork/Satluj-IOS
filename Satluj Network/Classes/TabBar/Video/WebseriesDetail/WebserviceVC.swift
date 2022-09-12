//
//  WebserviceVC.swift
//  Satluj Network
//
//  Created by Mac on 14/07/22.
//

import UIKit
import AVKit
import DropDown
import SwiftyStoreKit

class WebserviceVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var imgthumbnail: CustomImage!
    @IBOutlet weak var imgBlurrthumbnail: CustomImage!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var segmentControll: UIView!
    @IBOutlet weak var btnSeason: UIButton!
    @IBOutlet weak var cvWebseries: UICollectionView!
    @IBOutlet weak var heightcollectionview: NSLayoutConstraint!
    
    //MARK: - ViewModel
    var viewModel = WebserviceVCVM()
    let seasonDropDown = DropDown()
    private var segmentView = CustomSegmentedControl()
    var delegete:CollectionViewDelegate?
    var dataSource:CollectionViewDataSource<UICollectionViewCell,String>?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindableUIView()
        setUpSegmentView()
        handleCollectioview()
        setupSeasonDropDown()
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setTransparent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.removeTransparent(color: .white)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Function
    private func setUpSegmentView() {
        segmentView = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.segmentControll.bounds.size.height), buttonTitle: [SegmentText.episode,SegmentText.moredetail])
        segmentView.backgroundColor = .clear
        segmentView.delegate = self
        self.segmentControll.addSubview(segmentView)
    }
    
    
    func getData(){
        if AuthToken.isValid(){
            self.viewModel.checkPurchased { err in
                if let error = err {
                    self.showSwiftMessage(message: error)
                }
            }
        }
        
        self.viewModel.getWebseasonDetail { err in
            if let error = err {
                self.showSwiftMessage(message: error)
            }
        }
    }
    
    
    func bindableUIView(){
        self.viewModel.isLoading.bind { [weak self] status in
            guard let `self` = self else{return}
            if status{
                LoadingOverlay.shared.showOverlay(view: self.getWindow())
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
        self.viewModel.type.bind {[weak self] objType in
            guard let `self` = self else{return}
            self.cvWebseries.reloadData()
        }
        
        self.viewModel.objWerseries.bind {[weak self] objWebSeriesDetail in
            if let seriesDetail = objWebSeriesDetail{
                self?.setUpdate(model: seriesDetail)
                self?.seasonDropDown.dataSource = seriesDetail.getSeason.map({"Season \($0.season)"})
                self?.seasonDropDown.reloadAllComponents()
                self?.cvWebseries.reloadData()
            }
        }
        
    }
    
    func setUpdate(model:WebseriesDetailViewModel){
        self.lblName.text = model.name
        self.lblDescription.text = model.description
        self.btnSeason.setTitle("Season 1", for: .normal)
        self.lblYear.text = "\(model.releaseYear)  \(model.getEpisodesCount) episodes"
        if let seasonName = model.getSeason.filter { objSeason in
            return objSeason.id == model.id
        }.first {
            self.btnSeason.setTitle("Season \(seasonName.season)", for: .normal)
        }
        self.viewModel.seriesId = "\(model.id)"
        if let url = URL(string: API.ImageUrl.image + model.thumbNail.replacingOccurrences(of: " ", with: "%20")){
            imgBlurrthumbnail.loadImage(key: url.lastPathComponent, urlStr: url)
            imgBlurrthumbnail.applyBlurEffect()
        }
        if let url = URL(string: API.ImageUrl.image + model.thumbNail.replacingOccurrences(of: " ", with: "%20")){
            imgthumbnail.loadImage(key: url.lastPathComponent, urlStr: url)
        }
    }
    
    func setupSeasonDropDown() {
        
        seasonDropDown.anchorView = btnSeason
        
        seasonDropDown.bottomOffset = CGPoint(x: 0, y: btnSeason.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        if let objWebSeason = self.viewModel.objWerseries.value{
            seasonDropDown.dataSource = objWebSeason.getSeason.map({"Season \($0.season)"})
        }
       
        
        // Action triggered on selection
        seasonDropDown.selectionAction = { [weak self] (index, item) in
            guard let `self` = self else{return}
            self.btnSeason.setTitle("\(item)", for: .normal)
            if let objWebSeason = self.viewModel.objWerseries.value{
                if let season = objWebSeason.getSeason.filter({ objSeason in
                    return "Season \(objSeason.season)" == item
                }).first {
                    if self.viewModel.seriesId != "\(season.id)"{
                        self.viewModel.seriesId = "\(season.id)"
                        self.getData()
                    }
                }
            }
            
        }
    }
    func playVideo(url:String){
        guard let videoURL = URL(string: url) else {return}
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    
    //MARK: - PurchaseContent
    func purchaseContent(){
        LoadingOverlay.shared.showOverlay(view: self.getWindow())
        SwiftyStoreKit.purchaseProduct(InAppPurchaseId.purchaseId, quantity: 1, atomically: true) {[weak self] result in
            guard let `self` = self else{return}
            switch result {
            case .success(let purchase):
                let model = PriceModel(productId: purchase.productId, price: purchase.product.price.stringValue, identifier: purchase.product.priceLocale.currencyCode ?? "" , status: "done",token: purchase.transaction.transactionIdentifier ?? "")
                self.updatePurchase(model: model)
            case .error(let error):
                LoadingOverlay.shared.hideOverlayView()
                switch error.code {
                case .unknown: self.showSwiftMessage(message:"Unknown error. Please contact support")
                case .clientInvalid: self.showSwiftMessage(message:"Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: self.showSwiftMessage(message:"The purchase identifier was invalid")
                case .paymentNotAllowed: self.showSwiftMessage(message:"The device is not allowed to make the payment")
                case .storeProductNotAvailable: self.showSwiftMessage(message:"The product is not available in the current storefront")
                case .cloudServicePermissionDenied: self.showSwiftMessage(message:"Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: self.showSwiftMessage(message:"Could not connect to the network")
                case .cloudServiceRevoked: self.showSwiftMessage(message:"User has revoked permission to use this cloud service")
                default: self.showSwiftMessage(message:(error as NSError).localizedDescription)
                }
            }
        }
    }
    
    private func updatePurchase(model:PriceModel){
        self.viewModel.updatePurchase(model: model) { [weak self] err in
            LoadingOverlay.shared.hideOverlayView()
            if let error = err{
                self?.showSwiftMessage(message: error)
            }
        }
    }
    
    
    //MARK: - HandleCollectionview
    private func handleCollectioview(){
        cvWebseries.registerCustom(EpisodeCell.self)
        cvWebseries.registerCustom(MoredetailCell.self)
        cvWebseries.registerCustom(WebSeriesCastCell.self)
        delegete = CollectionViewDelegate(didSelectIndex: {[weak self] indexPath in
            guard let `self` = self else{return}
            if self.viewModel.type.value == .episode{
                if AuthToken.isValid(){
                    if GeneralHelper.shared.isPurchase{
                        if let series = self.viewModel.objWerseries.value{
                            self.playVideo(url: series.getEpisodes[indexPath.row].videoUrl)
                        }
                    }else{
                        self.purchaseContent()
                    }
                }else{
                    GeneralHelper.shared.showAlertLogin("", "You need to login to access this feature.") {
                        ScreenTransitions().logout()
                    }
                }
            }
        }, sizeForItem: { int in
            return CGSize.zero
        })
        
        dataSource = CollectionViewDataSource(cellForIndexPath: {[weak self] indexPath in
            guard let `self` = self else{return UICollectionViewCell()}
            if self.viewModel.type.value == .episode{
                if let cell = self.cvWebseries.dequeueCell(EpisodeCell.self, indexPath: indexPath){
                    if let series = self.viewModel.objWerseries.value{
                        cell.setData(model: series.getEpisodes[indexPath.row])
                    }
                    return cell
                }
            }else{
                if indexPath.section == 0{
                    if let cell = self.cvWebseries.dequeueCell(MoredetailCell.self, indexPath: indexPath){
                        cell.setData(model:self.viewModel.arrMoreDetail.value[indexPath.row] )
                        return cell
                    }
                }else{
                    if let cell = self.cvWebseries.dequeueCell(WebSeriesCastCell.self, indexPath: indexPath){
                        cell.setData(model: self.viewModel.arrCast.value[indexPath.row])
                        return cell
                    }
                }
                
            }
            
            return UICollectionViewCell()
        }, sections: 2, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            if self.viewModel.type.value == .episode{
                if let data = self.viewModel.objWerseries.value{
                    return data.getEpisodes.count
                }
                return 0
            }else{
                if section == 0{
                    return self.viewModel.arrMoreDetail.value.count
                }else{
                    return self.viewModel.arrCast.value.count
                }
                
            }
        })
        
        cvWebseries.delegate = delegete
        cvWebseries.dataSource = dataSource
        cvWebseries.collectionViewLayout = self.createCompositionalLayout()
        cvWebseries.reloadData()
    }
    
    //MARK: - CompositionalLayout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if self.viewModel.type.value == .episode{
               return self.createWebSeriesdetail()
            }else{
                if sectionIndex == 0{
                  return  self.createWebSeriesdetail()
                }else{
                   return self.createWebSeriesCastdetail()
                }
            }
            
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        layout.configuration = config
        return layout
    }
    
    
    func createWebSeriesdetail() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.SCREEN_WIDTH), heightDimension: .estimated(20))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    func createWebSeriesCastdetail() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(160))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(160))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        return layoutSection
    }
    
    //MARK: - Action
    @IBAction func btnTrailerPlay(_ sender: UIButton){
        if let series = self.viewModel.objWerseries.value{
            if let trailer = series.getTrailer{
                self.playVideo(url: trailer.videoUrl)
            }
        }
    }
    @IBAction func btnSeasonChange(_ sender: UIButton){
        seasonDropDown.show()
    }
    @IBAction func btnBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPlay(_ sender: UIButton){
        if let series = self.viewModel.objWerseries.value{
            if AuthToken.isValid(){
                if series.getEpisodes.isValidIndex(index: 0){
                    self.playVideo(url: series.getEpisodes[0].videoUrl)
                }
            }else{
                GeneralHelper.shared.showAlertLogin("", "You need to login to access this feature.") {
                    ScreenTransitions().logout()
                }
            }
        }
    }
    
}
extension WebserviceVC:CustomSegmentedControlDelegate{
    func change(to index: Int) {
        if index == 0{
            self.viewModel.type.value = .episode
        }else if index == 1{
            self.viewModel.type.value = .moredetail
        }
    }
}
