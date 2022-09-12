//
//  SearchVC.swift
//  Satluj Network
//
//  Created by Mohit on 22/04/22.
//

import UIKit

class SearchVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var cvSearch: UICollectionView!
    @IBOutlet weak var txtSaerch: UITextField!
    
    //MARK: - Variable
    var viewModel = SearchVCVM()
    var delegete:CollectionViewDelegate?
    var dataSource:CollectionViewDataSource<UICollectionViewCell,String>?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSaerch.becomeFirstResponder()
        self.txtSaerch.delegate = self
        setuTabGesture()
        bindableUiToView()
        handleCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated:  true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Function
    func setuTabGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    private func bindableUiToView(){
        self.viewModel.arrSearch.bind { [weak self] arr in
            self?.cvSearch.reloadData()
        }
    }
    func getData(search:String){
        self.viewModel.getSearchList(text: search) { err in
            if let error = err{
                GeneralHelper.shared.showAlert("", error, {})
            }
        }
    }
    
    
    
    private func handleCollectionView(){
        cvSearch.registerCustom(BookmarkCell.self)
//        cvSearch.addInfiniteScroll { [weak self] cv in
//            self?.getData(scroll: true)
//        }
//
//        cvSearch.setShouldShowInfiniteScrollHandler { [weak self] cv in
//
//            guard let `self` = self else { return false }
//            return self.viewModel.hasData.value
//        }
        delegete = CollectionViewDelegate(didSelectIndex: {[weak self] indexPath in
            guard let `self` = self else{return}
            if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.detailVC, storyboard: Storyboard.Name.categories) as? NewsDetailVC{
                vc.hidesBottomBarWhenPushed = true
                vc.viewModel = NewsDetailVCVM(newsId: self.viewModel.arrSearch.value[indexPath.row].id, objNews: self.viewModel.arrSearch.value[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, sizeForItem: { int in
            return CGSize.zero
        })
       
        dataSource = CollectionViewDataSource(cellForIndexPath: {[weak self] indexPath in
            guard let `self` = self else{return UICollectionViewCell()}
            if let cell = self.cvSearch.dequeueCell(BookmarkCell.self, indexPath: indexPath){
                cell.setdata(type: .bookmark, model: nil, searchModel: self.viewModel.arrSearch.value[indexPath.row])
                return cell
            }
            return UICollectionViewCell()
        }, sections: 1, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            return self.viewModel.arrSearch.value.count
        })
        
        
        cvSearch.delegate = delegete
        cvSearch.dataSource = dataSource
        cvSearch.collectionViewLayout = createCompositionalLayout()
        cvSearch.reloadData()
        
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
   
    //MARK: - Action
    @IBAction func btnBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCross(_ sender: UIButton){
        self.txtSaerch.text = ""
        self.viewModel.arrSearch.value.removeAll()
    }

}
extension SearchVC:UITextFieldDelegate{
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if (newString.count >= 1){
            self.getData(search: newString)
        }else if newString.isEmpty{
            self.viewModel.arrSearch.value.removeAll()
        }
        return true
    }
}
extension SearchVC:UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.cvSearch) == true {
            return false
        }
        return true
    }
}
