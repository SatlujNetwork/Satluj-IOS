//
//  LoginOptionVC.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import UIKit
import SafariServices
import GoogleSignIn
import AuthenticationServices

class LoginOptionVC: UIViewController {

    
    var viewModel = SignVCVM()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.overrideUserInterfaceStyle = .light
              overrideUserInterfaceStyle = .light
            }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    @IBAction func btnGoogle(_ sender: UIButton){
        GIDSignIn.sharedInstance.signIn(
           with: signInConfig,
           presenting: self
       ) {[weak self] user, error in
           guard error == nil else { return }
           guard let user = user else { return }
            DispatchQueue.main.async {
                self?.viewModel.isLoading.value = true
             let model = FacebookModel(model: user)
                GmailDetails.save(model)
            self?.viewModel.apiSocialLogin(model: model, type: .gmail, completion: { [weak self] error in
                self?.viewModel.isLoading.value = false
                if let err = error{
                    self?.showSwiftMessage(message: err)
                }else{
                    let vc = ScreenTransitions().moveTocontroller()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
        }
    }
    
    @IBAction func btnApple(_ sender: UIButton){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    @IBAction func btnSkip(_ sender: UIButton){
        let vc = Storyboard.getTabBar(identifier: Storyboard.Controller.tabBar, storyboard: Storyboard.Name.tabBar)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginOptionVC: ASAuthorizationControllerDelegate {

     // ASAuthorizationControllerDelegate function for authorization failed

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print(error.localizedDescription)
        
        GeneralHelper.shared.showAlert("", error.localizedDescription) {
        }

    }

       // ASAuthorizationControllerDelegate function for successful authorization

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            // Create an account as per your requirement

            let appleId = appleIDCredential.user

            let appleUserFirstName = appleIDCredential.fullName?.givenName

            let appleUserLastName = appleIDCredential.fullName?.familyName

            let appleUserEmail = appleIDCredential.email
            let model = FacebookModel()
            model.email = appleUserEmail ?? ""
            model.id = appleId
            model.name = appleUserFirstName ?? ""
            model.surname = appleUserLastName ?? ""
            self.viewModel.isLoading.value = true
            self.viewModel.apiSocialLogin(model: model, type: .apple, completion: { [weak self] error in
                self?.viewModel.isLoading.value = false
                if let err = error{
                    self?.showSwiftMessage(message: err)
                }else{
                    let vc = ScreenTransitions().moveTocontroller()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })

        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {

            let appleUsername = passwordCredential.user

            let applePassword = passwordCredential.password

            //Write your code
            GeneralHelper.shared.showAlert("", appleUsername) {
            }
        }

    }

}

extension LoginOptionVC: ASAuthorizationControllerPresentationContextProviding {

    //For present window

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return self.view.window!

    }

}
