//
//  MultipartRequestManager.swift
//  Satluj Network
//
//  Created by Mohit on 15/04/22.
//

import Foundation
//
//  MultipartRequestManager.swift
//  Chumsy
//
//  Created by osx on 01/10/21.
//

import Foundation
import Alamofire
import UIKit

class MultipartRequestManager:NSObject {
    
    //MARK: - Variable
     static var shared = MultipartRequestManager()
    
    
    //MARK: - UploadImageToServer
    
    func postApiDataWithMultipartForm<T:Decodable>(requestUrl: URL, request: ImageRequest?,parameter: [String:String], resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void)
    {
            AF.upload(multipartFormData: { (multipartFormData) in
                
                if let req = request
                {
                    multipartFormData.append(req.attachment, withName: "image", fileName: req.fileName, mimeType: "image/jpeg")
                }
                for (key, value) in parameter {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
               
            },to: requestUrl, usingThreshold: UInt64.init(), method: .post,headers: nil).response { response in
                print(response)
                if((response.error?.errorDescription == nil)){
                    do{
                        if let jsonData = response.data{
                            let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, Any>
                            if let data = parsedData["data"] as? Dictionary<String, Any>{
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                                    let response = try JSONDecoder().decode(T.self, from: jsonData)
                                    // here "jsonData" is the dictionary encoded in JSON data
                                    _=completionHandler(response)
                                
                                } catch {
                                    _=completionHandler(nil)
                                }
                            }else{
                                _=completionHandler(nil)
                            }
                        }
                    }catch{
                        _=completionHandler(nil)
                        print("error message")
                    }
                }else{
                    if response.error!._code == NSURLErrorTimedOut {
                        _=completionHandler(nil)
                    }
                    else
                    {
                        _=completionHandler(nil)
                    }
                }
            }
    }
    
  
}

struct ImageRequest : Encodable
{
    let attachment : Data
    let fileName : String
}
