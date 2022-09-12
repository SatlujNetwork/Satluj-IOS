//
//  SignUpVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit

class SignUpVC: UIViewController {
    
    var viewModel = SignUpVCVM()

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    //MARK: - Variable
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindableUiToView()
        if #available(iOS 13.0, *) {
              overrideUserInterfaceStyle = .light
            }
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Function
    func bindableUiToView(){
        self.viewModel.isLoading.bind { status in
            if status{
                LoadingOverlay.shared.showOverlay(view: self.getWindow())
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    
    //MARK: - Action
    @IBAction func btnBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    

    
    @IBAction func signUpButtonClicked(_ sender: Any)
    {
        guard let textName = self.nameTxt.text else{return}
        guard !textName.isEmpty else{ GeneralHelper.shared.showAlert("", Alert.CreateProfile.nameBlankMsg) {}
            return}
        guard let textEmail = self.emailTxt.text else{return}
        guard !textEmail.isEmpty,textEmail.isValidEmail else{ GeneralHelper.shared.showAlert("", Alert.CreateProfile.email_field_empty) {}
            return}
        guard let textPswd = self.passwordTxt.text else{return}
        guard !textPswd.isEmpty else{ GeneralHelper.shared.showAlert("", Alert.CreateProfile.pwdErrorMsg) {}
            return}
        self.view.endEditing(true)
        //    Register API
        viewModel.apiRegisteruser(name:textName, email: textEmail, password: textPswd) { [weak self] error in
            if let err = error{
                GeneralHelper.shared.showAlert("", err) {
                }
            }else{
                if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.verify, storyboard: Storyboard.Name.login) as? VerificationVC{
                    vc.viewModel = VerificationVCVM(email: textEmail)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    
    

}
