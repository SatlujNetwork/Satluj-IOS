//
//  ProfileVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit
import SwiftyStoreKit

class ProfileVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var cvProfile: UICollectionView!
    
    var logOutModel = LogoutVCVM()
    
    //MARK: - Variable
    var viewModel = ProfileVCVM()
    var delegate:CollectionViewDelegate?
    var datasource:CollectionViewDataSource<UICollectionViewCell,String>?
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindableModelToUI()
        handleCollectionView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.createProfileModel()
    }
    
    //MARK: - Function
    private func bindableModelToUI(){
        self.viewModel.createProfileModel()
        self.viewModel.arrProfile.bind { [weak self] arr in
            self?.cvProfile.reloadData()
        }
    }
    
    private func handleCollectionView(){
        cvProfile.registerCustom(ProfileCell.self)
        cvProfile.registerForSupplementaryHeader(HeaderInfoCell.self)
        cvProfile.registerForSupplementaryHeader(HeaderSettingCell.self)
        
        delegate = CollectionViewDelegate(didSelectIndex: {[weak self] indexPath in
            guard let `self` = self else {return}
            switch indexPath.section {
            case 0:
                if indexPath.row == 1{
                    if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.editProfile, storyboard: Storyboard.Name.profile) as? EditProfileVC{
                        vc.hidesBottomBarWhenPushed = true
                        vc.viewModel = EditProfileVCVM(user: self.viewModel.vm)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else if indexPath.row == 2{
                    GeneralHelper.shared.showAlertActionSheet("Logout!", "Are you sure you want to logout?") { [weak self] in
                        self?.view.endEditing(true)
                        
                        self?.logOutModel.apiLogoutClicked { [weak self] err,status in
                            GeneralHelper.shared.showAlert(nil, "User Logged Out Successfully") {
                                ScreenTransitions().logout()
                            }
                        }
                    }
                }
            default:
                if indexPath.row == 0{
                    if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.bookmark, storyboard: Storyboard.Name.profile) as? BookmarksVC{
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else if indexPath.row == 1{
                    guard let url = URL(string: "http://news.apollow.com/contactus_detail") else { return }
                    UIApplication.shared.open(url)
                }
                else if indexPath.row == 2{
                    guard let url = URL(string: "http://news.apollow.com/privacy_policy") else { return }
                    UIApplication.shared.open(url)
                }else if indexPath.row == 3{
                    guard let url = URL(string: "http://news.apollow.com/about_us") else { return }
                    UIApplication.shared.open(url)
                }
                else if indexPath.row == 4{
                    GeneralHelper.shared.showAlertActionSheetTheme("Set Theme", "") { //Light Theme
                        UserDefaults.standard.set("Light", forKey: "theme")
                      //  GeneralHelper.shared.setUpTabbar(bgColor: ColorPalette.navigationBarColour)
                        UIApplication.shared.windows.first { $0.isKeyWindow }!.overrideUserInterfaceStyle = .light
                    } _: { // Dark Theme
                        UserDefaults.standard.set("Dark", forKey: "theme")
                     //   GeneralHelper.shared.setUpTabbar(bgColor: ColorPalette.navigationBarColour)
                        UIApplication.shared.windows.first { $0.isKeyWindow }!.overrideUserInterfaceStyle = .dark
                    }

                }
            }
           
        }, sizeForItem: { int in
            CGSize.zero
        })
        
        datasource = CollectionViewDataSource(cellForIndexPath: { indexPath in
            let model = self.viewModel.arrProfile.value[indexPath.section].items[indexPath.row]
            if let cell = self.cvProfile.dequeueCell(ProfileCell.self, indexPath: indexPath){
                cell.setData(model: model)
                return cell
            }
            return UICollectionViewCell()
        }, sections: viewModel.arrProfile.value.count, rowsInSection: {[weak self] section in
            guard let `self` = self else{return 0}
            return self.viewModel.arrProfile.value[section].items.count
        })
        
        datasource?.sectionHeaderView = { [weak self] indexPath in
            guard let `self` = self else{return UICollectionReusableView()}
            let model = self.viewModel.arrProfile.value[indexPath.section]
            switch model.type {
            case .profile:
                if let sectionHeader = self.cvProfile.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderInfoCell.reuseIdentifier, for: indexPath) as? HeaderInfoCell{
                    sectionHeader.setData(model: model)
                    return sectionHeader
                }
            default:
                if let sectionHeader = self.cvProfile.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSettingCell.reuseIdentifier, for: indexPath) as? HeaderSettingCell{
                    sectionHeader.setData(model: model)
                    return sectionHeader
                }
            }
            return UICollectionReusableView()
        }
        
        cvProfile.delegate = delegate
        cvProfile.dataSource = datasource
        cvProfile.collectionViewLayout = self.createCompositionalLayout()
        cvProfile.reloadData()
    }
    
    
    //MARK: - CompositionalLayout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let model = self.viewModel.arrProfile.value[sectionIndex]
            return self.createProfile(model: model)
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    
    func createProfile(model:ProfileModelSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.SCREEN_WIDTH), heightDimension: .absolute(45))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(45))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let layoutSectionHeader = createHeader(model: model)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    
    func createHeader(model:ProfileModelSection) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: model.type == .profile ? .absolute(180) : .absolute(55))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    
    //MARK: - Action
    @IBAction func btnDeleteAccount(_ sender: UIButton){
        GeneralHelper.shared.showAlertActionSheet("Delete user!", "Are you sure you want to delete this account?") { [weak self] in
            self?.view.endEditing(true)
            self?.logOutModel.apiDelete { err,status in
                GeneralHelper.shared.showAlert(nil, "User deleted Successfully") {
                    ScreenTransitions().logout()
                }
            }
        }

    }
    @IBAction func btnRestorePurchase(_ sender: UIButton){
        LoadingOverlay.shared.showOverlay(view: self.getWindow())
        SwiftyStoreKit.restorePurchases { result in
            LoadingOverlay.shared.hideOverlayView()
            for purchase in result.restoredPurchases {
                if let transtion = purchase.originalTransaction{
                    switch transtion.transactionState {
                    case .purchased, .restored:
                       
                        if purchase.productId == InAppPurchaseId.purchaseId{
                            GeneralHelper.shared.isPurchase = true
                        }
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        GeneralHelper.shared.showAlert("", "Purchase restored successfully") {}
                        // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    }
                }
            }
        }
    }
}
