//
//  HLRClient.swift
//  HHLRG
//
//  Created by Nathan Wood on 25/09/2015.
//  Copyright © 2015 Nathan Wood. All rights reserved.
//

import Foundation

struct Credential {
    let username: String
    let password: String
}

struct UserInfo {
    let collectingSamples: Bool
}

class Client {
    
    static let ErrorDomain = "kHHLRGClientErrorDomain"
    static let DevelopmentBaseURL = NSURL(string: "http://hhlrg.woodnathan.com/milk/")!
    static let ProductionBaseURL = NSURL(string: "https://breastfeeding.bcs.uwa.edu.au/milk/")!
    
    let baseURL: NSURL
    private let session: NSURLSession
    
    var credential: Credential?
    
    init(baseURL: NSURL) {
        self.baseURL = baseURL
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: configuration)
    }
    
    func fetchUserInfo(completionHandler: (UserInfo?, NSError?) -> Void)
    {
        let req = request("user_info")
        dataTaskWithRequest(req) { (responseObject, error) -> Void in
            var userInfo: UserInfo? = nil
            if let response = responseObject as! NSDictionary? {
                let collectingSamples = response.objectForKey("user")?.objectForKey("collecting_samples") as? Bool ?? false
                userInfo = UserInfo(collectingSamples: collectingSamples)
            }
            completionHandler(userInfo, error)
        }
    }
    
    private static let APIPath = "api/api.php?_action="
    private func request(action: String, parameters: AnyObject? = nil) -> NSURLRequest {
        let actionPath = Client.APIPath.stringByAppendingString(action)
        let URL = NSURL(string: actionPath, relativeToURL: self.baseURL)
        
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "POST"
        
        if let credentials = self.credential {
            request.setValue(credentials.username, forHTTPHeaderField: "X-Mother-Username")
            request.setValue(credentials.password, forHTTPHeaderField: "X-Mother-Password")
        }
        
        if let params = parameters {
            let paramData = try! NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
            request.HTTPBody = paramData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func dataTaskWithRequest(request: NSURLRequest, completionHandler: (AnyObject?, NSError?) -> Void) -> NSURLSessionDataTask {
        let task = session.dataTaskWithRequest(request) { (data, response, var error) -> Void in
            var responseObject: AnyObject? = data
            if let HTTPResponse = response as! NSHTTPURLResponse? {
                if HTTPResponse.allHeaderFields["Content-Type"] as! String == "application/json" {
                    responseObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                }
                
                if let JSONObject = responseObject as? NSDictionary {
                    let errorDict = JSONObject.objectForKey("error") as? NSDictionary
                    error = NSError.ClientError(errorDict)
                    if error != nil {
                        responseObject = nil
                    }
                }
            }
            
            completionHandler(responseObject, error)
        }
        task.resume()
        return task
    }
}