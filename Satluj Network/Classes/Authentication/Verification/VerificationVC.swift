//
//  VerificationVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 15/04/22.
//

import UIKit

class VerificationVC: UIViewController,UITextFieldDelegate {

    //MARK: - Outlet
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtSecond: UITextField!
    @IBOutlet weak var txtThird: UITextField!
    @IBOutlet weak var txtFourth: UITextField!
    
    //MARK: - Variable
    var viewModel = VerificationVCVM()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        bindableUi()
        setUpTextField()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Function
    func bindableUi(){
        self.viewModel.isLoading.bind { [weak self] status in
            guard let `self` = self else{return}
            if status{
                LoadingOverlay.shared.showOverlay(view: self.getWindow())
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    
    func setUpTextField(){
        txtFirst.textContentType = .oneTimeCode
        txtSecond.textContentType = .oneTimeCode
        txtThird.textContentType = .oneTimeCode
        txtFourth.textContentType = .oneTimeCode
        txtFirst.delegate = self
        txtSecond.delegate = self
        txtThird.delegate = self
        txtFourth.delegate = self
        self.txtFirst.becomeFirstResponder()
    }
    
    //MARK: - Action
    @IBAction func btnConfirm(_ sender: UIButton)
    {
        if let txtFirst = txtFirst.text, !txtFirst.isEmpty, let txtwo = txtSecond.text, !txtwo.isEmpty, let txthree = txtThird.text, !txthree.isEmpty, let txFour = txtFourth.text, !txFour.isEmpty{
            let strOpt = txtFirst+txtwo+txthree+txFour
            self.viewModel.verifyEmail(otp: strOpt) { [weak self] err in
                if let error = err{
                    self?.showSwiftMessage(message: error)
                }else{
                    let vc =  ScreenTransitions().moveTocontroller()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            GeneralHelper.shared.showAlert("", Alert.CreateProfile.optAError) {}
        }
        
    }
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendOtp(_ sender: UIButton)
    {
        self.viewModel.sendVerifyEmail { [weak self] err in
            if let error = err{
                self?.showSwiftMessage(message: error)
            }else{
                self?.showSwiftMessage(message: "OTP has been sent to your email please check.")
            }
        }
    }
    
    
   //MARK: - TextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if ((textField.text?.count)! < 1  && string.count > 0){
            if(textField == txtFirst)
            {
                txtSecond.becomeFirstResponder()
            }
            if(textField == txtSecond)
            {
                txtThird.becomeFirstResponder()
            }
            if(textField == txtThird)
            {
                txtFourth.becomeFirstResponder()
            }
            if(textField == txtFourth)
            {
                txtFourth.resignFirstResponder()
            }
           
            textField.text = string
            self.setUpButton()
            return false
        }
        else if ((textField.text?.count)! >= 1  && string.count == 0){
            // on deleting value from Textfield
            if(textField == txtSecond)
            {
                txtFirst.becomeFirstResponder()
            }
            if(textField == txtThird)
            {
                txtSecond.becomeFirstResponder()
            }
            if(textField == txtFourth)
            {
                txtThird.becomeFirstResponder()
            }
            textField.text = ""
            self.setUpButton()
            return false
        }
        else if ((textField.text?.count)! >= 1  )
        {
            switch textField{
            case txtFirst:
                txtSecond.becomeFirstResponder()
            case txtSecond:
                txtThird.becomeFirstResponder()
            case txtThird:
                txtFourth.becomeFirstResponder()
            case txtFourth:
                txtFourth.becomeFirstResponder()
            default:
                break
            }
            textField.text = string
        }
        self.setUpButton()
        return true
    }
    func setUpButton()
    {
        if let txtFirst = txtFirst.text, !txtFirst.isEmpty, let txtwo = txtSecond.text, !txtwo.isEmpty, let txthree = txtThird.text, !txthree.isEmpty, let txFour = txtFourth.text, !txFour.isEmpty{
            let strOpt = txtFirst+txtwo+txthree+txFour
        }
    }
    
    
}
