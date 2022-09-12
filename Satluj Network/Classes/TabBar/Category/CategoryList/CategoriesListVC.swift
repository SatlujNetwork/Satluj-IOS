//
//  CategoriesListVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit
import UIScrollView_InfiniteScroll

class CategoriesListVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var cvCategoryLsit: UICollectionView!
    @IBOutlet weak var imgCategory: CustomImage!
    @IBOutlet weak var lblNameCategory: UILabel!
    
    //MARK: - Variable
    var viewModel = CategoriesListVCVM()
    var delegete:CollectionViewDelegate?
    var dataSource:CollectionViewDataSource<UICollectionViewCell,String>?
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindableUI()
        getData(infiniteScroll: false)
        handleCollectionview()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setTransparent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.removeTransparent(color: .clear)
    }
    
    //MARK: - Function
    private func getData(infiniteScroll:Bool){
        if let objCategory = self.viewModel.objCategory.value{
            self.viewModel.getPopularNewsListHome(cat_id: objCategory.id,isInfiniteScroll: infiniteScroll) {  err in
                if let error = err{
                    GeneralHelper.shared.showAlert("", error,{})
                }else{
                    self.cvCategoryLsit.finishInfiniteScroll()
                }
            }
        }
    }
    private func bindableUI(){
        self.viewModel.objCategory.bind {[weak self] objCategory in
            if let category = objCategory{
                self?.setData(value: category)
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
        self.viewModel.arrcategoryList.bind {[weak self] arrNews in
            self?.cvCategoryLsit.reloadData()
            self?.cvCategoryLsit.finishInfiniteScroll()
        }
    }
    
    private func setData(value:CategoryViewModel){
        self.lblNameCategory.text = value.name
        if let url = URL(string: API.ImageUrl.image + value.cover_image){
            self.imgCategory.loadImage(key: url.lastPathComponent, urlStr: url)
        }
        else
        {
            self.imgCategory.image = UIImage(named: "dummy")
        }
    }
    
    private func handleCollectionview(){
        cvCategoryLsit.registerCustom(CategoriesListCell.self)
        cvCategoryLsit.addInfiniteScroll { [weak self] cv in
            self?.getData(infiniteScroll: true)
        }
        
        cvCategoryLsit.setShouldShowInfiniteScrollHandler { [weak self] cv in
            
            guard let `self` = self else { return false }
            return self.viewModel.hasData.value
        }
        delegete = CollectionViewDelegate(didSelectIndex: { indexPath in
            if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.detailVC, storyboard: Storyboard.Name.categories) as? NewsDetailVC{
                vc.hidesBottomBarWhenPushed = true
                vc.viewModel = NewsDetailVCVM(newsId: self.viewModel.arrcategoryList.value[indexPath.row].id, objNews: self.viewModel.arrcategoryList.value[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, sizeForItem: { int in
            return CGSize.zero
        })
        
        dataSource = CollectionViewDataSource(cellForIndexPath: {[weak self] indexPath in
            guard let `self` = self else{return UICollectionViewCell()}
            if let cell = self.cvCategoryLsit.dequeueCell(CategoriesListCell.self, indexPath: indexPath){
                let obj = self.viewModel.arrcategoryList.value[indexPath.row]
                cell.setData(type: .category, model: obj)
                return cell
            }
            return UICollectionViewCell()
        }, sections: 1, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            return self.viewModel.arrcategoryList.value.count
        })
        
        cvCategoryLsit.delegate = delegete
        cvCategoryLsit.dataSource = dataSource
        cvCategoryLsit.collectionViewLayout = createCompositionalLayout()
        cvCategoryLsit.reloadData()
    }
    //MARK: - CompositionalLayout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return self.createCategoryList()
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
    

    
    //MARK: - Action
    @IBAction func btnBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
