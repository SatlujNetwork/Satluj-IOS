//
//  BookmarksVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit
import UIScrollView_InfiniteScroll

class BookmarksVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var cvBookmark: UICollectionView!
    
    //MARK: - Variable
    var viewModel = BookmarksVCVM()
    var delegete:CollectionViewDelegate?
    var dataSource:CollectionViewDataSource<UICollectionViewCell,String>?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindableUI()
        handleCollectionView()
        getData(scroll: false)
        
        self.setLeftItemWithBack(NavigationTitle.bookmark, andBack: UIImage(named: "backk")!) { [weak self] status in
            self?.navigationController?.popViewController(animated: true)
        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Function
    private func getData(scroll:Bool){
        self.viewModel.getBookmarkList(isScroll: scroll) { [weak self] err in
            if let error = err{
                GeneralHelper.shared.showAlert("", error, {})
            }else{
                self?.cvBookmark.finishInfiniteScroll()
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
        self.viewModel.arrBookmark.bind { [weak self] arr in
            self?.cvBookmark.reloadData()
        }
    }
    
    
    private func handleCollectionView(){
        cvBookmark.registerCustom(BookmarkCell.self)
        cvBookmark.addInfiniteScroll { [weak self] cv in
            self?.getData(scroll: true)
        }
        
        cvBookmark.setShouldShowInfiniteScrollHandler { [weak self] cv in
            
            guard let `self` = self else { return false }
            return self.viewModel.hasData.value
        }
        delegete = CollectionViewDelegate(didSelectIndex: {[weak self] indexPath in
            guard let `self` = self else{return}
            if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.detailVC, storyboard: Storyboard.Name.categories) as? NewsDetailVC{
                vc.hidesBottomBarWhenPushed = true
                if let news = self.viewModel.arrBookmark.value[indexPath.row].getNews{
                    vc.viewModel = NewsDetailVCVM(newsId: news.id, objNews: news)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, sizeForItem: { int in
            return CGSize.zero
        })
       
        dataSource = CollectionViewDataSource(cellForIndexPath: {[weak self] indexPath in
            guard let `self` = self else{return UICollectionViewCell()}
            if let cell = self.cvBookmark.dequeueCell(BookmarkCell.self, indexPath: indexPath){
                cell.setdata(type: .bookmark, model: self.viewModel.arrBookmark.value[indexPath.row])
                return cell
            }
            return UICollectionViewCell()
        }, sections: 1, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            return self.viewModel.arrBookmark.value.count
        })
        
        
        cvBookmark.delegate = delegete
        cvBookmark.dataSource = dataSource
        cvBookmark.collectionViewLayout = createCompositionalLayout()
        cvBookmark.reloadData()
        
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
