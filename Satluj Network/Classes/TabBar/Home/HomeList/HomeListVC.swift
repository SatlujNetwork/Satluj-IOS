//
//  HomeListVC.swift
//  Satluj Network
//
//  Created by Mohit on 09/05/22.
//

import UIKit
import Alamofire

class HomeListVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var cvHome: UICollectionView!
    
    
    //MARK: - Variable
    var viewModel = HomeListVCVM()
    var delegate : CollectionViewDelegate?
    var refresher = UIRefreshControl()
    var dataSource : CollectionViewDataSource<UICollectionViewCell,String>?
    
    //MARK: - Lifecycel
    override func viewDidLoad() {
        super.viewDidLoad()
        bindableUiToView()
        handleColletionView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
     //MARK: - Function
    func bindableUiToView(){
        self.viewModel.title.bind { [weak self] objTitle in
            guard let `self` = self else {return}
                self.viewModel.fetchNewsFromRealm(catID: self.viewModel.mapCategory.value[self.viewModel.selectedIndex.value].id)
                if self.viewModel.selectedIndex.value == 0{
                    self.getBanner()
                }
                self.getPopularNewsdata(catid: self.viewModel.mapCategory.value[self.viewModel.selectedIndex.value].id)
        }
        
        self.viewModel.mapNewspopularList.bind {[weak self] arrNews in
            self?.refresher.endRefreshing()
            self?.cvHome.reloadData()
        }
        
        self.viewModel.isLoading.bind { [weak self] status in
            guard let `self` = self else{return}
            if status{
                LoadingOverlay.shared.showOverlay(view: self.getWindow())
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
        
        self.viewModel.arrBannerList.bind {[weak self] aeeNews in
            self?.refresher.endRefreshing()
            self?.cvHome.reloadData()
        }
    }
    
    func getBanner(){
        viewModel.getBanner { [weak self] err in
            guard let `self` = self else{return}
            if let error = err
            {
                self.showSwiftMessage(message: error)
            }
        }
    }
    
  
    func getSliderdata(catid:Int)
    {
        viewModel.getMainCategoryList(cat_id: catid) { [weak self] err in
            guard let `self` = self else{return}
            if let error = err
            {
                self.showSwiftMessage(message: error)
            }
        }
    }
    
    func getPopularNewsdata(catid:Int)
    {
        viewModel.getPopularNewsListHome(cat_id: catid) { [weak self] err in
            if let error = err
            {
                self?.showSwiftMessage(message: error)
            }
            else{
                if self?.viewModel.mapNewspopularList.value.count == 0
                {
                    self?.showSwiftMessage(message: "No Popular News found")
                }
            }
        }
        
    }

    private func handleColletionView(){
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        cvHome.refreshControl = refresher
        cvHome.registerCustom(HomeNewsCell.self)
        cvHome.registerCustom(HomePhotoCell.self)
        cvHome.registerCustom(CategoriesListCell.self)
        cvHome.registerForSupplementaryHeader(HomeNewsHeaderCell.self)
       cvHome.registerForSupplementaryFooter(HomeNewsFooterCell.self)


        delegate = CollectionViewDelegate(didSelectIndex: {[weak self] indexPath in
            guard let `self` = self else{return}
            if self.viewModel.selectedIndex.value == 0{
                if indexPath.section == 0{
                    if indexPath.row == 0{
                        if self.viewModel.arrBannerList.value[indexPath.row].type == "Webseries"{
                            if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.webseries, storyboard: Storyboard.Name.video) as? WebserviceVC{
                                vc.hidesBottomBarWhenPushed = true
                                vc.viewModel = WebserviceVCVM(seriesId: "\(self.viewModel.arrBannerList.value[indexPath.row].typeContent)")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }else{
                            if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.detailVC, storyboard: Storyboard.Name.categories) as? NewsDetailVC{
                                vc.hidesBottomBarWhenPushed = true
                                vc.viewModel = NewsDetailVCVM(newsId: self.viewModel.arrBannerList.value[indexPath.row].id, objNews: nil)
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                    }else{
                        if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.detailVC, storyboard: Storyboard.Name.categories) as? NewsDetailVC{
                            vc.hidesBottomBarWhenPushed = true
                            vc.viewModel = NewsDetailVCVM(newsId: self.viewModel.mapNewspopularList.value[indexPath.row].id, objNews: self.viewModel.mapNewspopularList.value[indexPath.row])
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }else{
                    if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.detailVC, storyboard: Storyboard.Name.categories) as? NewsDetailVC{
                        vc.hidesBottomBarWhenPushed = true
                        vc.viewModel = NewsDetailVCVM(newsId: self.viewModel.mapNewspopularList.value[indexPath.row].id, objNews: self.viewModel.mapNewspopularList.value[indexPath.row])
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }else{
                if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.detailVC, storyboard: Storyboard.Name.categories) as? NewsDetailVC{
                    vc.hidesBottomBarWhenPushed = true
                    vc.viewModel = NewsDetailVCVM(newsId: self.viewModel.mapNewspopularList.value[indexPath.row].id, objNews: self.viewModel.mapNewspopularList.value[indexPath.row])
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }

        }, sizeForItem: { int in
            return CGSize.zero
        })
        

        dataSource = CollectionViewDataSource(cellForIndexPath: {[weak self] indexPath in
            guard let `self` = self else {return UICollectionViewCell()}
            if self.viewModel.selectedIndex.value == 0{
                if indexPath.section == 0{
                    if let cell = self.cvHome.dequeueCell(HomePhotoCell.self, indexPath: indexPath){
                        cell.setData(values: self.viewModel.arrBannerList.value[indexPath.row])

                        return cell
                    }
                }else{
                    if let cell = self.cvHome.dequeueCell(HomeNewsCell.self, indexPath: indexPath){
                        cell.setUpData(values: self.viewModel.mapNewspopularList.value[indexPath.row])
                        return cell
                    }
                }
            }else{
                if let cell = self.cvHome.dequeueCell(CategoriesListCell.self, indexPath: indexPath){
                    cell.setData(type: .category, model: self.viewModel.mapNewspopularList.value[indexPath.row])
                    return cell
                }
            }

            return UICollectionViewCell()
        }, sections: 2, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            if self.viewModel.selectedIndex.value == 0{
                if section == 0{
                    return self.viewModel.arrBannerList.value.count
                }else{
                    return self.viewModel.mapNewspopularList.value.count > 10 ? 10 : self.viewModel.mapNewspopularList.value.count
                }
            }else{
                if section == 0{
                    return self.viewModel.mapNewspopularList.value.count
                }else{
                    return 0
                }

            }
        })
        dataSource?.sectionHeaderView = { [weak self] indexPath in
            guard let `self` = self else{ return UICollectionReusableView()}
            if let header = self.cvHome.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeNewsHeaderCell.reuseIdentifier, for: indexPath) as? HomeNewsHeaderCell{
                header.btnViewAllClick = { [weak self] in
                    guard let `self` = self else{return}
                    if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.viewAll, storyboard: Storyboard.Name.home) as? ViewAllVC{
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                return header
            }
            return UICollectionReusableView()
        }
        dataSource?.sectionFooterView = { [weak self] indexPath in
            guard let `self` = self else{ return UICollectionReusableView()}
            if let footer = self.cvHome.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeNewsFooterCell.reuseIdentifier, for: indexPath) as? HomeNewsFooterCell{
                if indexPath.section == 0{
                    footer.setNumberOfpage(count: self.viewModel.arrBannerList.value.count)
                }
                return footer
            }
            return UICollectionReusableView()
        }

        cvHome.delegate = delegate
        cvHome.dataSource = dataSource
        cvHome.collectionViewLayout = self.createCompositionalLayout()
        cvHome.reloadData()
    }
    
    @objc func refreshData() {
        if self.viewModel.selectedIndex.value == 0{
            self.getBanner()
        }
        self.getPopularNewsdata(catid: self.viewModel.mapCategory.value[self.viewModel.selectedIndex.value].id)
    }
    
    func updateFooter(index:Int){

        let indexPath = IndexPath(row: 0, section: 0)
        
        guard let footer = cvHome.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath) as? HomeNewsFooterCell else { return }
        footer.updateIndicator(index: index)
   }


    //MARK: - CompositionalLayout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if self.viewModel.selectedIndex.value == 0{
                if sectionIndex == 0{
                    return self.createPhotoNews()
                }else{
                    return self.createListNews()
                }
            }else{
                return self.createListNews()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }


    func createPhotoNews() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.SCREEN_WIDTH), heightDimension: .absolute(250))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))

        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        layoutSection.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
            if let last = visibleItems.last{
                let index = last.indexPath.row
                self?.updateFooter(index: index)
            }
        }
        if self.viewModel.selectedIndex.value == 0{
            let layoutSectionFooter = createFooter()
            layoutSection.boundarySupplementaryItems = [layoutSectionFooter]
        }
        return layoutSection
    }
    func createListNews() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.SCREEN_WIDTH), heightDimension: .estimated(20))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))

        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        if self.viewModel.selectedIndex.value == 0{
            let layoutSectionHeader = createHeader()
            layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        }
        return layoutSection
    }
    func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    func createFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25))
        let layoutSectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        return layoutSectionFooter
    }
}
