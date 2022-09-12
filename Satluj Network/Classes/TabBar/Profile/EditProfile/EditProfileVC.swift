//
//  EditProfileVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit

class EditProfileVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var imgUser: CustomImage!
    @IBOutlet weak var lblName: UITextField!
    
    //MARK: - Variable
    var viewModel = EditProfileVCVM()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindableUi()
//        self.setLeftItemWithBack(NavigationTitle.editProfile, andBack: UIImage(named: "backk")!) { [weak self] status in
//            self?.navigationController?.popViewController(animated: true)
//        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Action
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdate(_ sender: UIButton)
    {
        guard let text = self.lblName.text else{ return}
        if text.isEmpty{
            GeneralHelper.shared.showAlert("", "Please add name first") {
            }
            return
        }
        self.viewModel.uploadImage(name: text, data: self.imgUser.image!.jpegData(compressionQuality: 0.8)!) { result, message in
            GeneralHelper.shared.showAlert("", "Profile updated Successfully ") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func btnAddImage(_ sender: UIButton)
    {
        let imageActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: NSLocalizedString(Alert.Button.camera, comment: ""), style: .default) { _ in
            self.openCamera(mediaType: "public.image")
        }
        let actionGallery = UIAlertAction(title: NSLocalizedString(Alert.Button.gallery, comment: ""), style: .default) { _ in
            self.openGallery(mediaType: "public.image")
        }
        imageActionSheet.addAction(actionGallery)
        imageActionSheet.addAction(actionCamera)
        let actionCancel = UIAlertAction(title: Alert.Button.Cancel, style: .cancel, handler: nil)
        imageActionSheet.addAction(actionCancel)
        self.present(imageActionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Function
    // MARK: - Open Camera/Gallery
    func openCamera(mediaType: String) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = [mediaType]
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery(mediaType: String) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [mediaType]
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    func bindableUi(){
        self.viewModel.objUser.bind{[weak self] obj in
            if let user = obj{
                self?.setData(model: user)
            }
        }
        self.viewModel.isLoading.bind { status in
            if status{
                LoadingOverlay.shared.showOverlay(view: self.getWindow())
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    func setData(model:SIgnInViewModel){
        if let url = URL(string:model.pic){
            imgUser.loadImage(key: url.lastPathComponent, urlStr: url)
        }
        else
        {
            imgUser.image = UIImage(named: "dummy")
        }
        self.lblName.text = model.name
    }

   
}
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {return}
        switch mediaType {
        case "public.movie":
            print("")
        case "public.image":
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                self.imgUser.contentMode = .scaleAspectFill
                self.imgUser.image = image
                self.viewModel.isImageUpdate.value = true
            }
            
        default:
            break
        }
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
    
}
    
