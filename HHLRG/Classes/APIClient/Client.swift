//
//  HLRClient.swift
//  HHLRG
//
//  Created by Nathan Wood on 25/09/2015.
//  Copyright © 2015 Nathan Wood. All rights reserved.
//

import Foundation

enum Time {
    case Days(Int)
    case Hours(Int)
    
    var seconds: NSTimeInterval {
        switch self {
        case let .Days(days):
            return NSTimeInterval(days) * 24.0 * 60.0 * 60.0;
        case let .Hours(hours):
            return NSTimeInterval(hours) * 60.0 * 60.0;
        }
    }
}

struct Credential {
    let username: String
    let password: String
}

struct UserInfo {
    let collectingSamples: Bool
    let acceptedConsentForm: Bool
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
        
        var identifier: String {
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
        
        var identifier: String {
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
        
        var identifier: String {
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
        var weight: Int?
        var date: NSDate?
        
        func serialize(dateFormatter: NSDateFormatter) -> NSDictionary
        {
            let f = NSMutableDictionary()
            
            if let w = weight {
                f.setObject(w, forKey: "weight")
            }
            if let id = identifier {
                f.setObject(id, forKey: "SID")
            }
            if let d = date {
                f.setObject(dateFormatter.stringFromDate(d), forKey: "date")
            }
            
            return NSDictionary(dictionary: f)
        }
    }
    
    private(set) var new = true
    
    var type: FeedType!
    var subtype: Subtype!
    var side: Side!
    var comment: String!
    
    var before: Sample! = Sample(identifier: nil, weight: nil, date: nil)
    var after: Sample! = Sample(identifier: nil, weight: nil, date: nil)
    
    func validate() -> [ ValidationError ]
    {
        var errors: [ ValidationError ] = []
        
        if type == nil {
            errors.append(ValidationError.Error("The feed type cannot be empty"))
        } else {
            if type == .Supplementary {
                if subtype == nil {
                    errors.append(ValidationError.Error("The supplementary type cannot be empty"))
                }
            } else if side == nil {
                errors.append(ValidationError.Error("The breast side cannot be empty"))
            }
        }
        
        
        if before.date == nil {
            errors.append(ValidationError.Error("The start date and time cannot be empty"))
        }
        if after.date == nil {
            errors.append(ValidationError.Error("The end date and time cannot be empty"))
        }
        
        if before.weight == nil {
            errors.append(ValidationError.Error("The weight before cannot be empty"))
        }
        if after.weight == nil {
            errors.append(ValidationError.Error("The weight after cannot be empty"))
        }
        
        if let before = before.date, after = after.date {
            if before.compare(after) != NSComparisonResult.OrderedAscending {
                errors.append(ValidationError.Error("The end date and time must occur after the start date and time"))
            }
            
            let duration = after.timeIntervalSinceDate(before)
            if duration >= Time.Hours(1).seconds {
                let durationString = NSString(format: "%.f", (duration / 60.0))
                errors.append(ValidationError.Warning("The duration of this feed is \(durationString) minutes"))
            }
        }
        
        if let before = before.weight, after = after.weight {
            if after <= before {
                errors.append(ValidationError.Warning("The weights entered indicate a weight loss"))
            }
        }
        
        if let firstError = errors.first {
            if firstError.level == .Error {
                return [ firstError ]
            }
        }
        
        return errors
    }
    
    func serialize(dateFormatter: NSDateFormatter) -> NSDictionary
    {
        let f = NSMutableDictionary()
        
        f.setObject(type.identifier, forKey: "type")
        if type == FeedType.Supplementary {
            f.setObject(subtype.identifier, forKey: "subtype")
        } else {
            f.setObject(side.identifier, forKey: "side")
        }
        
        f.setObject(comment ?? "", forKey: "comment")
        
        f.setObject(before.serialize(dateFormatter), forKey: "before")
        f.setObject(after.serialize(dateFormatter), forKey: "after")
        
        return NSDictionary(dictionary: f)
    }
}

struct ValidationError {
    enum Level {
        case Warning
        case Error
    }
    
    let level: Level
    let message: String
    
    static func Warning(message: String) -> ValidationError {
        return ValidationError(level: .Warning, message: message)
    }
    static func Error(message: String) -> ValidationError {
        return ValidationError(level: .Error, message: message)
    }
}

class Client {
    
    static let ErrorDomain = "kHHLRGClientErrorDomain"
    static let DevelopmentBaseURL = NSURL(string: "http://hhlrg.woodnathan.com/milk/")!
    static let ProductionBaseURL = NSURL(string: "https://breastfeeding.bcs.uwa.edu.au/milk/")!
    
    let baseURL: NSURL
    private let session: NSURLSession
    private let dateFormatter = NSDateFormatter()
    private let serializeDateFormatter = NSDateFormatter()
    
    private(set) var feeds: [Feed]
    var credential: Credential? {
        willSet {
            feeds = []
        }
    }
    
    init(baseURL: NSURL) {
        self.baseURL = baseURL
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: configuration)
        
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        serializeDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        serializeDateFormatter.timeZone = NSTimeZone.localTimeZone()//(abbreviation: "UTC")
        serializeDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        feeds = []
    }
    
    func validateFeed(feed: Feed) -> [ ValidationError ] {
        var errors: [ ValidationError ] = []
        
        errors.appendContentsOf(feed.validate())
        if let firstError = errors.first {
            if firstError.level == .Error {
                return [ firstError ]
            }
        }
        
        var allFeeds = feeds
        allFeeds.append(feed)
        
        let sortedFeeds = allFeeds.sort({ $0.before.date?.compare($1.before.date!) == NSComparisonResult.OrderedAscending })
        let minDate = sortedFeeds.first?.before.date
        let maxDate = sortedFeeds.last?.after.date
        
        if let min = minDate, max = maxDate {
            if max.timeIntervalSinceDate(min) > Time.Days(1).seconds {
                errors.append(ValidationError.Warning("The total time span for the feeds would be greater than 24 hours"))
            }
        }
        
        return errors
    }
    
    func fetchUserInfo(completionHandler: (UserInfo?, NSError?) -> Void)
    {
        let req = request("user_info")
        dataTaskWithRequest(req) { (responseObject, error) -> Void in
            var userInfo: UserInfo? = nil
            if let response = responseObject as! NSDictionary?, userDict = response.objectForKey("user") {
                let collectingSamples = userDict.objectForKey("collecting_samples") as? Bool ?? false
                let acceptedConsentForm = userDict.objectForKey("accepted_consent_form") as? Bool ?? false
                userInfo = UserInfo(collectingSamples: collectingSamples, acceptedConsentForm: acceptedConsentForm)
            }
            completionHandler(userInfo, error)
        }
    }
    
    func fetchFeeds(completionHandler: ([Feed], NSError?) -> Void)
    {
        let req = request("get_feeds")
        dataTaskWithRequest(req) { (responseObject, error) -> Void in
            var feeds: [Feed] = []
            if let response = responseObject as? NSDictionary {
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
                    
                    return Feed(new: false, type: type, subtype: subtype, side: side, comment: comment, before: beforeSample, after: afterSample)
                }).filter({ $0.comment.localizedCaseInsensitiveContainsString("delete") == false }).sort({ $0.before.date?.compare($1.before.date!) == NSComparisonResult.OrderedAscending }) ?? []
                
                self.feeds = feeds
            }
            completionHandler(feeds, error)
        }
    }
    
    func createOrUpdateFeed(feed: Feed, completionHandler: ([Feed], NSError?) -> Void)
    {
        if feed.new {
            createFeed(feed, completionHandler: completionHandler)
        } else {
            updateFeed(feed, completionHandler: completionHandler)
        }
    }
    
    func createFeed(feed: Feed, completionHandler: ([Feed], NSError?) -> Void)
    {
        let feedDict = feed.serialize(serializeDateFormatter)
        let feedDicts = [feedDict]
        let params = ["feeds" : feedDicts]
        
        let req = request("add_feeds", parameters: params)
        dataTaskWithRequest(req) { (responseObject, error) -> Void in
            if error == nil {
                self.fetchFeeds(completionHandler)
            } else {
                completionHandler([], error)
            }
        }
    }
    
    func updateFeed(feed: Feed, completionHandler: ([Feed], NSError?) -> Void)
    {
        let feedDict = feed.serialize(serializeDateFormatter)
        let feedDicts = [feedDict]
        let params = ["feeds" : feedDicts]
        
        let req = request("edit_feeds", parameters: params)
        dataTaskWithRequest(req) { (responseObject, error) -> Void in
            if error == nil {
                self.fetchFeeds(completionHandler)
            } else {
                completionHandler([], error)
            }
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