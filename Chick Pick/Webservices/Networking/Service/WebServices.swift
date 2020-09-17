//
//  WebServices.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 24/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit


typealias CompletionResponse = (JSON,Bool) -> ()

class WebService{
    
    static let shared = WebService()
    
    private init() {}
    
    
    // //-------------------------------------
    // MARK:- Method for Get, post..
    //-------------------------------------
    
    func requestMethod(api: ApiKey, httpMethod:Method, parameters: Any, completion: @escaping CompletionResponse){
        
        guard isConnected else {
            completion(JSON(), false);
            return
        }
        
        var parameterString = "/"
        if httpMethod == .get{
            if let param = parameters as? [String:Any]{
                let dictData = param as! [String:String]
                for value in dictData.values {
                    parameterString += String(value) //+ "/"
                }
            }
        }
        else { parameterString = "" }
        
        guard let url = URL(string: NetworkEnvironment.baseURL + api.rawValue + parameterString) else {
            completion(JSON(),false)
            return
        }
        
        if url.absoluteString.contains("https://maps.googleapis") {
        }else {
            print("the url is \(url) and the parameters are \n \(parameters)")
        }
        
        let method = Alamofire.HTTPMethod.init(rawValue: httpMethod.rawValue)!
        
        var params = parameters
        
        if(method == .get)
        {
            params = [:]
        }
        
        //        if let strAPIKey = UserDefaults.standard.value(forKey: "X_API_KEY")
        //        {
        //            NetworkEnvironment.headers = ["x-api-key" : strAPIKey] as! [String : String]
        //        }
        
        Alamofire.request(url, method: method, parameters: params as? [String : Any], encoding: URLEncoding.httpBody, headers: NetworkEnvironment.headers).validate()
            .responseJSON { (response) in
                // LoaderClass.hideActivityIndicator()
                
                print("The webservice call is for \(url) and the params are \n \(JSON(parameters))")
                
                if let json = response.result.value{
                    let resJson = JSON(json)
                    print("the response is \(resJson)")
                    let status = resJson["status"].boolValue
                    completion(resJson, status)
                }
                else {
                    //  LoaderClass.hideActivityIndicator()
                    if let error = response.result.error {
                        print("Error = \(error.localizedDescription)")
                        completion(JSON(), false)
                        AlertMessage.showMessageForError(error.localizedDescription)
                    }
                }
        }
    }
    
    func getMethod(url: URL, httpMethod:Method, completion: @escaping CompletionResponse)
    {
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: NetworkEnvironment.headers)
            .validate()
            .responseJSON { (response) in
                // LoaderClass.hideActivityIndicator()
                
                //                print("The webservice call is for \(url)")
                
                if url.absoluteString.contains("https://maps.googleapis") {
                }else {
                    print("The webservice call is for \(url) ")
                }
                
                if let json = response.result.value{
                    let resJson = JSON(json)
                    print("the response is \(resJson)")
                    
                    if "\(url)".contains("geocode/json?latlng=") {
                        let status = resJson["status"].stringValue.lowercased() == "ok"
                        completion(resJson, status)
                    }
                    else {
                        let status = resJson["status"].boolValue
                        completion(resJson, status)
                    }
                }
                else {
                    //  LoaderClass.hideActivityIndicator()
                    if let error = response.result.error {
                        print("Error = \(error.localizedDescription)")
                        completion(JSON(), false)
                        AlertMessage.showMessageForError(error.localizedDescription)
                    }
                }
        }
    }
    
    // //-------------------------------------
    // MARK:- Multiform Data
    //-------------------------------------
    
    func uploadMultipartFormData(api: ApiKey,from images: [String:UIImage],completion: @escaping CompletionResponse){
        
        guard isConnected else { completion(JSON(), false); return }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in images{
                    if let imageData = value.jpegData(compressionQuality: 0.6) {
                        multipartFormData.append(imageData, withName: key, mimeType: "image/jpeg")
                    }
                }
                
        },usingThreshold:10 * 1024 * 1024,
          to: (NetworkEnvironment.baseURL + api.rawValue), method:.post,
          headers:NetworkEnvironment.headers,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    func postDataWithImage(api: ApiKey, parameter dictParams: [String: Any], image: UIImage, imageParamName: String, completion: @escaping CompletionResponse) {
        
        guard isConnected else { completion(JSON(), false); return }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imageData = image.jpegData(compressionQuality: 0.6) {
                
                multipartFormData.append(imageData, withName: imageParamName, fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in dictParams {
                if JSONSerialization.isValidJSONObject(value) {
                    let array = value as! [String]
                    
                    for string in array {
                        if let stringData = string.data(using: .utf8) {
                            multipartFormData.append(stringData, withName: key+"[]")
                        }
                    }
                } else {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                }
            }
        }, usingThreshold: 10 *  1024 * 1024, to: (NetworkEnvironment.baseURL + api.rawValue),
           method: .post, headers: NetworkEnvironment.headers) { (encodingResult) in
            switch encodingResult
            {
            case .success(let upload,_,_):
                
                upload.responseJSON {
                    response in
                    
                    print("Response : ", response)
                    
                    if let json = response.result.value {
                        
                        if (json as AnyObject).object(forKey:("status")) as! Bool == false {
                            let resJson = JSON(json)
                            completion(resJson, false)
                        }
                        else {
                            let resJson = JSON(json)
                            
                            completion(resJson, true)
                        }
                    }
                    else {
                        if let error = response.result.error {
                            print("Error = \(error.localizedDescription)")
                        }
                    }
                }
            case .failure( _):
                print("failure")
                break
            }
        }
    }
    
    
    func postDataWithImages(api: ApiKey, parameter dictParams: [String: Any], images: [UIImage], imageParamNames: [String], completion: @escaping CompletionResponse) {
        
        guard isConnected else { completion(JSON(), false); return }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            var index = 0
            
            for imageName in imageParamNames {
                
                if let imageData = images[index].jpegData(compressionQuality: 0.6) {
                    
                    multipartFormData.append(imageData, withName: imageName, fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                index += 1
            }
            
            for (key, value) in dictParams {
                if JSONSerialization.isValidJSONObject(value) {
                    let array = value as! [String]
                    
                    for string in array {
                        if let stringData = string.data(using: .utf8) {
                            multipartFormData.append(stringData, withName: key+"[]")
                        }
                    }
                } else {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                }
            }
        }, usingThreshold: 10 *  1024 * 1024, to: (NetworkEnvironment.baseURL + api.rawValue),
           method: .post, headers: NetworkEnvironment.headers) { (encodingResult) in
            switch encodingResult
            {
            case .success(let upload,_,_):
                
                upload.responseJSON {
                    response in
                    
                    print("Response : ", response)
                    
                    if let json = response.result.value {
                        
                        if (json as AnyObject).object(forKey:("status")) as! Bool == false {
                            let resJson = JSON(json)
                            completion(resJson, false)
                        }
                        else {
                            let resJson = JSON(json)
                            
                            completion(resJson, true)
                        }
                    }
                    else {
                        if let error = response.result.error {
                            print("Error = \(error.localizedDescription)")
                        }
                    }
                }
            case .failure( _):
                print("failure")
                break
            }
        }
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]
    }
}

extension WebService{
    var isConnected : Bool{
        guard isConnectedToInternet() else {
            AlertMessage.showMessageForError("Please connect to internet")
            //  LoaderClass.hideActivityIndicator()
            return false
        }
        return true
    }
    func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

