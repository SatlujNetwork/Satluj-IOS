//
//  ViewAllVC.swift
//  Satluj Network
//
//  Created by Mohit on 11/05/22.
//

import UIKit

class ViewAllVC: UIViewController {
 
    //MARK: - Outlet
    @IBOutlet weak var cvViewAll: UICollectionView!
    
    
    //MARK: - Variable
    var viewModel = ViewAllVCVM()
    var delegete:CollectionViewDelegate?
    var dataSource:CollectionViewDataSource<UICollectionViewCell,String>?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindableUI()
        handleCollectionView()
        getData(scroll: false)
        self.setLeftItemWithBack(NavigationTitle.explore, andBack: UIImage(named: "backk")!) { [weak self] status in
            self?.navigationController?.popViewController(animated: true)
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Function
    private func getData(scroll:Bool){
        self.viewModel.getPopularNewsListHome(isLoadMore: scroll) { [weak self] err in
            if let error = err{
                GeneralHelper.shared.showAlert("", error, {})
            }else{
                self?.cvViewAll.finishInfiniteScroll()
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
        self.viewModel.mapNewspopularList.bind { [weak self] arr in
            self?.cvViewAll.reloadData()
        }
    }
    
    
    private func handleCollectionView(){
        cvViewAll.registerCustom(BookmarkCell.self)
        cvViewAll.addInfiniteScroll { [weak self] cv in
            self?.getData(scroll: true)
        }
        
        cvViewAll.setShouldShowInfiniteScrollHandler { [weak self] cv in
            
            guard let `self` = self else { return false }
            return self.viewModel.hasData.value
        }
        delegete = CollectionViewDelegate(didSelectIndex: {[weak self] indexPath in
            guard let `self` = self else{return}
            if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.detailVC, storyboard: Storyboard.Name.categories) as? NewsDetailVC{
                vc.hidesBottomBarWhenPushed = true
                let news = self.viewModel.mapNewspopularList.value[indexPath.row]
                vc.viewModel = NewsDetailVCVM(newsId: news.id, objNews: news)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, sizeForItem: { int in
            return CGSize.zero
        })
       
        dataSource = CollectionViewDataSource(cellForIndexPath: {[weak self] indexPath in
            guard let `self` = self else{return UICollectionViewCell()}
            if let cell = self.cvViewAll.dequeueCell(BookmarkCell.self, indexPath: indexPath){
                cell.setdata(type: .bookmark,model: nil, searchModel: self.viewModel.mapNewspopularList.value[indexPath.row])
                return cell
            }
            return UICollectionViewCell()
        }, sections: 1, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            return self.viewModel.mapNewspopularList.value.count
        })
        
        
        cvViewAll.delegate = delegete
        cvViewAll.dataSource = dataSource
        cvViewAll.collectionViewLayout = createCompositionalLayout()
        cvViewAll.reloadData()
        
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.SCREEN_WIDTH), heightDimension: .absolute(130))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
    

   

}
