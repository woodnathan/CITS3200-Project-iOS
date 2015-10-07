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

struct Feed {
    enum FeedType {
        case Breastfeed
        case Expression
        case Supplementary
        
        static func fromString(value: String?) -> FeedType? {
            if let v = value?.uppercaseString.characters.first {
                switch v {
                case "B":
                    return FeedType.Breastfeed
                case "E":
                    return FeedType.Expression
                case "S":
                    return FeedType.Supplementary
                default:
                    break
                }
            }
            return nil
        }
        
        var identifier: Character {
            switch self {
            case .Breastfeed:
                return "B"
            case .Expression:
                return "E"
            case .Supplementary:
                return "S"
            }
        }
    }
    enum Side {
        case Left
        case Right
        
        static func fromString(value: String?) -> Side? {
            if let v = value?.uppercaseString.characters.first {
                switch v {
                case "L":
                    return Side.Left
                case "R":
                    return Side.Right
                default:
                    break
                }
            }
            return nil
        }
        
        var identifier: Character {
            switch self {
            case .Left:
                return "L"
            case .Right:
                return "R"
            }
        }
    }
    enum Subtype {
        case Expressed
        case Formula
        
        static func fromString(value: String?) -> Subtype? {
            if let v = value?.uppercaseString.characters.first {
                switch v {
                case "E":
                    return Subtype.Expressed
                case "F":
                    return Subtype.Formula
                default:
                    break
                }
            }
            return nil
        }
        
        var identifier: Character {
            switch self {
            case .Expressed:
                return "E"
            case .Formula:
                return "F"
            }
        }
    }
    
    struct Sample {
        var identifier: Int?
        var weight: Int
        var date: NSDate!
    }
    
    var type: FeedType!
    var subtype: Subtype!
    var side: Side!
    var comment: String!
    
    var before: Sample!
    var after: Sample!
}

class Client {
    
    static let ErrorDomain = "kHHLRGClientErrorDomain"
    static let DevelopmentBaseURL = NSURL(string: "http://hhlrg.woodnathan.com/milk/")!
    static let ProductionBaseURL = NSURL(string: "https://breastfeeding.bcs.uwa.edu.au/milk/")!
    
    let baseURL: NSURL
    private let session: NSURLSession
    private let dateFormatter = NSDateFormatter()
    
    var credential: Credential?
    
    init(baseURL: NSURL) {
        self.baseURL = baseURL
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: configuration)
        
        self.dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        self.dateFormatter.timeZone = NSTimeZone.localTimeZone()
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
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
    
    func fetchFeeds(completionHandler: ([Feed]?, NSError?) -> Void)
    {
        let req = request("get_feeds")
        dataTaskWithRequest(req) { (responseObject, error) -> Void in
            var feeds: [Feed]? = nil
            if let response = responseObject as! NSDictionary? {
                let feedDicts = response.objectForKey("feeds") as? [NSDictionary]
                feeds = feedDicts?.map({ (dict: NSDictionary) -> Feed in
                    var beforeSample: Feed.Sample? = nil
                    var afterSample: Feed.Sample? = nil
                    if let before = dict["before"] as? NSDictionary {
                        let identifier = before["SID"] as? Int
                        let weight = before["weight"] as? Int ?? 0
                        let date = self.dateFormatter.dateFromString(before["date"] as! String)
                        beforeSample = Feed.Sample(identifier: identifier, weight: weight, date: date)
                    }
                    if let after = dict["after"] as? NSDictionary {
                        let identifier = after["SID"] as? Int
                        let weight = after["weight"] as? Int ?? 0
                        let date = self.dateFormatter.dateFromString(after["date"] as! String)
                        afterSample = Feed.Sample(identifier: identifier, weight: weight, date: date)
                    }
                    
                    let type = Feed.FeedType.fromString(dict["type"] as? String)
                    let subtype = Feed.Subtype.fromString(dict["subtype"] as? String)
                    let side = Feed.Side.fromString(dict["side"] as? String)
                    let comment = dict["comment"] as? String
                    
                    return Feed(type: type, subtype: subtype, side: side, comment: comment, before: beforeSample, after: afterSample)
                }).sort({ $0.before.date.compare($1.before.date) == NSComparisonResult.OrderedAscending })
            }
            completionHandler(feeds, error)
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
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(responseObject, error)
            })
        }
        task.resume()
        return task
    }
}