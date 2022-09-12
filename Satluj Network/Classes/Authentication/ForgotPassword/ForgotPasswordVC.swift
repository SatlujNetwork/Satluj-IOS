//
//  ForgotPasswordVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var submitBtn: LoadingButton!
    var viewModel = ForgotPasswordVCVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindableUiToView()
        let tapComment = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewBackground.addGestureRecognizer(tapComment)
        if #available(iOS 13.0, *) {
              overrideUserInterfaceStyle = .light
            }
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
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

    
    
    @IBAction func btnSubmit(_ sender: UIButton)
    {
        if let text = self.txtEmail.text, text.isValidEmail{
                self.view.endEditing(true)
                viewModel.apiForgotPassword(email: text) { [weak self] error in
                    if let err = error{
                        self?.showSwiftMessage(message: err)
                    }else{
                        GeneralHelper.shared.showAlert(nil, "An email has been sent with reset password link") {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            
        }else {
            self.showSwiftMessage(message: Alert.CreateProfile.email_field_empty)
        }
    }
}
