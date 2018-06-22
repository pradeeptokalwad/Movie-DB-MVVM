//
//  APIManager.swift
//  Movie DB
//
//  Created by webwerks on 6/22/18.
//  Copyright © 2018 Pradeep. All rights reserved.
//

import Foundation


enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
}

enum Domain: String {
    case v3 = "https://api.themoviedb.org/3"
    case v4 = "https://api.themoviedb.org/4"
}

class APIManager {
    
    fileprivate func setConfiguration() ->URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        let session = URLSession(configuration: configuration)
        
        return session
    }
    
    func getServiceRequest(path: String, params: JSONDict? = nil, isAPIRequired: Bool, domain:Domain, completion: @escaping (_ success: Bool, _ object: AnyObject?, _ errorMessage:String?) -> ()) {
        
        let urlRequest = prepareRequest(path: path, isAPIRequired: isAPIRequired, params: params, domain:domain)
        dataTask(request: urlRequest, method: HttpMethod.GET.rawValue, completion: completion)
    }
    
    func postServiceRequest(path: String, params: JSONDict? = nil, isAPIRequired: Bool, domain:Domain, completion: @escaping (_ success: Bool, _ object: AnyObject?, _ errorMessage:String?) -> ()) {
        
        let urlRequest = prepareRequest(path: path, isAPIRequired: isAPIRequired, params: params, domain:domain)
        dataTask(request: urlRequest, method: HttpMethod.POST.rawValue, completion: completion)
    }
    
    fileprivate func networkConnection(session:URLSession, request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) ->Void) {
        session.dataTask(with: request) { (data, response, error) -> Void in
            completionHandler(data, response, error)
            }.resume()
    }
    
    fileprivate func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?, _ errorMessage:String?) -> ()) {
        
        request.httpMethod = method
        let session = setConfiguration()
        
        networkConnection(session: session, request: request as URLRequest) { (data, response, error) in

            DispatchQueue.main.async {
                if let data = data {
                    let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    var json: [String : AnyObject]!
                    if jsonResponse is Dictionary<String, AnyObject> {
                        json = jsonResponse as? [String : AnyObject]
                    }else {
                        let responseArray =  jsonResponse as? [AnyObject]
                        json = (responseArray?.count != 0) ? responseArray?[0] as? [String : AnyObject] : nil
                    }

                    completion(true, json as AnyObject?,error?.localizedDescription)
                    
                }else if ((error) != nil) {
                    completion(false, nil, error?.localizedDescription)
                }
            }
        }
    }
    
    private func prepareRequest(path: String, isAPIRequired:Bool, params: JSONDict? = nil, domain:Domain) -> NSMutableURLRequest {
        
        var completeURLString = getDomain(domainUse: domain)
        
        completeURLString = completeURLString + path
        var request = NSMutableURLRequest()
        if let param = params {
            var paramData:NSMutableData?
            for (key, value) in param {
                if paramData == nil {
                    paramData = NSMutableData(data: "\(key)=\(value)".data(using: String.Encoding.utf8)!)
                }else {
                    paramData?.append("&\(key)=\(value)".data(using: String.Encoding.utf8)!)
                }
            }
            
            if let postData = paramData {
                request.httpBody = postData as Data
            }
        }else {
            print("Complete URL : \(completeURLString)")
        }

        completeURLString = completeURLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        request.url  = NSURL(string: completeURLString)! as URL
        request = setConfigurationOnRequest(request: request, isTokenRequired: true)
        
        return request
    }
    
    fileprivate func getDomain(domainUse:Domain) -> String {
        switch domainUse {
        case .v3:
            return Domain.v3.rawValue
        case .v4:
            return Domain.v4.rawValue
        }
    }
    
    fileprivate func setConfigurationOnRequest(request:NSMutableURLRequest, isTokenRequired:Bool) ->NSMutableURLRequest {
        let _request = request
        _request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return _request
    }
}


