//
//  SignInVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit

class SignInVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var viewEmail : UIView!
    @IBOutlet weak var viewPassword : UIView!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var viewBackground : UIView!
    
    
    var viewModel = SignVCVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        bindableUiToView()
        // Do any additional setup after loading the view.
    }
    
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
    
    
    @IBAction func btnLogin(_ sender: UIButton)
      {
          guard let text = self.txtEmail.text else{return}
          guard !text.isEmpty,text.isValidEmail else{
              GeneralHelper.shared.showAlert("", Alert.CreateProfile.email_field_empty) {}
              return
          }
          guard let pswd = self.txtPassword.text else{return}
          guard !pswd.isEmpty else{
              GeneralHelper.shared.showAlert("", Alert.CreateProfile.pwdErrorMsg) {}
              return
          }
          self.view.endEditing(true)
          viewModel.apiLogin(email: text, password: pswd) { [weak self] error in
              if let err = error{
                  GeneralHelper.shared.showAlert("", err) {}
              }else{
                  if let user = UserProfileCache.get(){
                      if user.emailVerifiedAt != nil{
                          let vc =  ScreenTransitions().moveTocontroller()
                          self?.navigationController?.pushViewController(vc, animated: true)
                      }else{
                          self?.viewModel.sendVerifyEmail(email: text, completion: { error in
                          })
                          if let vc = Storyboard.getViewController(identifier: Storyboard.Controller.verify, storyboard: Storyboard.Name.login) as? VerificationVC{
                              vc.viewModel = VerificationVCVM(email: text)
                              self?.navigationController?.pushViewController(vc, animated: true)
                          }
                      }
                  }
                 
              }
          }
      }
}
