//
//  EditProfileVCVM.swift
//  Satluj Network
//
//  Created by Mohit on 15/04/22.
//

import Foundation
class EditProfileVCVM{
    
    //MARK: - Variable
    private (set) var objUser:Bindable<SIgnInViewModel?> = Bindable(nil)
    private (set) var isLoading:Bindable<Bool> = Bindable(false)
    private (set) var isImageUpdate:Bindable<Bool> = Bindable(false)
    
    //MARK: init
    init(user:SIgnInViewModel) {
        self.objUser.value = user
    }
    init() {
        
    }

    //MARK: - ApiCall
    func uploadImage(name:String,data: Data, completionHandler: @escaping(_ result: SignIn?,String) -> Void){
        isLoading.value = true
        var param = [String:String]()
        param[APIParameters.registerUser.name] = name
        param[APIParameters.registerUser.id] = Userid.get()
        param[APIParameters.registerUser.loginToken] = AuthToken.get()
        param[APIParameters.registerUser.deviceType] = UniversalText.deviceType
        param[APIParameters.registerUser.deviceToken] = deviceToken
        let imageUploadRequest = ImageRequest(attachment: data, fileName: "\((UUID().uuidString)).jpg")
        MultipartRequestManager.shared.postApiDataWithMultipartForm(requestUrl: URL(string: CONFIG.serverConfig() + "/\(ApiUrl.updateProfile)")!, request: imageUploadRequest, parameter: param, resultType: SignIn.self) {[weak self] (response) in
            self?.isLoading.value = false
            if let user = response{
                UserProfileCache.save(user)
            }
            completionHandler(response,imageUploadRequest.fileName)
        }
    }
    
}

