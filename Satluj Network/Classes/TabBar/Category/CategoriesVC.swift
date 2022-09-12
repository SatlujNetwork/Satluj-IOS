//
//  CategoriesVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit
import SDWebImage

class CategoriesVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var cvCategory: UICollectionView!
    
    
    //MARK: - Variable
    var viewModel = CategorysVCVM()
    var refresher = UIRefreshControl()
    var delegate:CollectionViewDelegate?
    var datasource:CollectionViewDataSource<UICollectionViewCell,String>?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindableUiToView()
        let nib = UINib(nibName: "CategoriesCell", bundle: nil)
        cvCategory?.register(nib, forCellWithReuseIdentifier: "CategoriesCell")
        self.getData()
        handleCollectionView()
        // Do any additional setup after loading the view.
    }
    
    
    func bindableUiToView(){
        viewModel.mapCategory.bind { [weak self] mapsData in
            self?.cvCategory.reloadData()
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
    
    // fecth category from server
    
    func getData(){
        viewModel.getMainCategoryList { [weak self] err in
            self?.refresher.endRefreshing()
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
    
    //MARK: - Function
    private func handleCollectionView(){
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        cvCategory.refreshControl = refresher
        self.cvCategory.delegate = self
        self.cvCategory.dataSource = self
        self.cvCategory.collectionViewLayout = createCompositionalLayout()
        
    }
    
    @objc func refreshData() {
       getData()
    }
    
}

//MARK: - CollectionView Delegate and DataSource


extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let value = viewModel.mapCategory.value[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
        cell.lblTitle.text = value.name
        
        if let url = URL(string: API.ImageUrl.image + value.cover_image){
            cell.imgCategory.loadImage(key: url.lastPathComponent, urlStr: url)
        }
        else
        {
            cell.imgCategory.image = UIImage(named: "dummy")
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.viewModel.mapCategory.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.categoryList, storyboard: Storyboard.Name.categories) as? CategoriesListVC{
            vc.hidesBottomBarWhenPushed = true
            vc.viewModel = CategoriesListVCVM(model: self.viewModel.mapCategory.value[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute((ScreenSize.SCREEN_WIDTH-10)/2), heightDimension: .absolute((ScreenSize.SCREEN_WIDTH-10)/2))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
}
