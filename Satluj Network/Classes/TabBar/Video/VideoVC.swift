//
//  VideoVC.swift
//  Satluj Network
//
//  Created by Mohit on 15/03/22.
//

import UIKit
import UIScrollView_InfiniteScroll
import Alamofire


class VideoVC: UIViewController {
   
    //MARK: - Outlet
    @IBOutlet weak var cvVideo: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //MARK: - Variable
    var viewModel = VideoVCVM()
    var delegete:CollectionViewDelegate?
    var dataSource:CollectionViewDataSource<UICollectionViewCell,String>?
    var sortView:SortView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentControl.layer.backgroundColor = UIColor.white.cgColor
        handleCollectioview()
        addSortView()
        bindableui()
        getData(scroll: false)

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Function
    private func addSortView(){
        sortView = SortView(frame: self.view.frame)
        sortView?.addView(on: self.getWindow(), cancelHander: {[weak self] in
            self?.sortView?.hide()
        })
    }
    
    private func getData(scroll:Bool){
        self.viewModel.getVideoList(isInfiniteScroll: scroll) { [weak self] err in
            if let error = err{
                GeneralHelper.shared.showAlert("", error, {})
            }else{
                self?.cvVideo.finishInfiniteScroll()
            }
        }
    }
    private func bindableui(){
        self.viewModel.arrVideoList.bind {[weak self] arrNews in
            self?.cvVideo.reloadData()
        }
        self.viewModel.isLoading.bind { [weak self] status in
            guard let `self` = self else{return}
            if status{
                LoadingOverlay.shared.showOverlay(view: self.getWindow())
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
        self.viewModel.type.bind {[weak self] value in
            self?.cvVideo.reloadData()
        }
    }
    
    
    
    private func handleCollectioview(){
        cvVideo.registerCustom(CategoriesListCell.self)
        cvVideo.registerCustom(WebseriesCell.self)
        cvVideo.addInfiniteScroll { [weak self] cv in
            self?.getData(scroll: true)
        }
        cvVideo.setShouldShowInfiniteScrollHandler { [weak self] cv in
            guard let `self` = self else { return false }
            if self.viewModel.type.value == .video{
                return self.viewModel.hasDataVideo.value
            }else{
                return self.viewModel.hasDataWebseries.value
            }
           
        }
        delegete = CollectionViewDelegate(didSelectIndex: { indexPath in
            if self.viewModel.type.value == .video{
                if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.detailVC, storyboard: Storyboard.Name.categories) as? NewsDetailVC{
                    vc.hidesBottomBarWhenPushed = true
                    vc.viewModel = NewsDetailVCVM(newsId: self.viewModel.arrVideoList.value[indexPath.row].id, objNews: self.viewModel.arrVideoList.value[indexPath.row])
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.webseries, storyboard: Storyboard.Name.video) as? WebserviceVC{
                    vc.hidesBottomBarWhenPushed = true
                    vc.viewModel = WebserviceVCVM(seriesId: "\(self.viewModel.arrWebSeries.value[indexPath.row].id)")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }, sizeForItem: { int in
            CGSize.zero
        })
        dataSource = CollectionViewDataSource(cellForIndexPath: {[weak self] indexPath in
            guard let `self` = self else {return UICollectionViewCell()}
            if self.viewModel.type.value == .video{
                if let cell = self.cvVideo.dequeueCell(CategoriesListCell.self, indexPath: indexPath){
                    let value = self.viewModel.arrVideoList.value[indexPath.row]
                    cell.setData(type: .video, model: value)
                    return cell
                }
            }else{
                if let cell = self.cvVideo.dequeueCell(WebseriesCell.self, indexPath: indexPath){
                    let value = self.viewModel.arrWebSeries.value[indexPath.row]
                    cell.setData(model: value)
                    return cell
                }
            }
            return UICollectionViewCell()
        }, sections: 1, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            if self.viewModel.type.value == .video{
                return self.viewModel.arrVideoList.value.count
            }else{
                return self.viewModel.arrWebSeries.value.count
            }
           
        })
        cvVideo.delegate = delegete
        cvVideo.dataSource = dataSource
        cvVideo.collectionViewLayout = self.createCompositionalLayout()
        cvVideo.reloadData()
        
    }
     

    //MARK: - CompositionalLayout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if self.viewModel.type.value == .video{
                return self.createCategoryList()
            }else{
                return self.createWebseriesList()
            }
            
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    
    func createCategoryList() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.SCREEN_WIDTH), heightDimension: .estimated(20))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    func createWebseriesList() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.SCREEN_WIDTH), heightDimension: .absolute(110))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
    
    
    //MARK: - Action
    @IBAction func btnSort(_ sender: UIButton){
        sortView?.show()
    }
    
    
    @IBAction func segmentControll(_ sender: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 0{
            self.viewModel.type.value = .video
        }else{
            self.viewModel.type.value = .webSeries
        }
    }
    
    
}
