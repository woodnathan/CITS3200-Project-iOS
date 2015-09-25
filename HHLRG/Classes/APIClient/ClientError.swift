//
//  ClientError.swift
//  HHLRG
//
//  Created by Nathan Wood on 25/09/2015.
//  Copyright © 2015 Nathan Wood. All rights reserved.
//

import Foundation

/**
const POST_METHOD_REQUIRED = 100;
const API_ACTION_REQUIRED = 101;
const API_ACTION_INVALID = 103;
const USERNAME_HEADER_REQUIRED = 104;
const PASSWORD_HEADER_REQUIRED = 105;
const CONTENT_TYPE_JSON_REQUIRED = 106;
const REQUEST_FORMAT_INVALID = 107;

const UNKNOWN_USER_ACCOUNT = 200;
const INCORRECT_USER_PASSWORD = 201;

const FEED_INVALID_TYPE = 300;
const FEED_SIDE_REQUIRED = 301;
const FEED_EXPRESSION_SIDE_REQUIRED = 302;
const FEED_SUBTYPE_REQUIRED = 303;
const FEED_INVALID_BEFORE_DATE = 304;
const FEED_INVALID_AFTER_DATE = 305;
const FEED_INVALID_DATES = 306;

const SAMPLE_SAVE_FAILED = 400;
const SAMPLE_FETCH_FAILED = 401;

private static $messages = array(
self::POST_METHOD_REQUIRED => 'POST method required',
self::API_ACTION_REQUIRED => 'no action provided',
self::API_ACTION_INVALID => 'invalid action provided',
self::USERNAME_HEADER_REQUIRED => 'X-Mother-Username header required',
self::PASSWORD_HEADER_REQUIRED => 'X-Mother-Password header required',
self::CONTENT_TYPE_JSON_REQUIRED => 'Content-Type must be application/json',
self::REQUEST_FORMAT_INVALID => 'request format is invalid',

self::UNKNOWN_USER_ACCOUNT => 'unknown user account',
self::INCORRECT_USER_PASSWORD => 'invalid password',

self::FEED_INVALID_TYPE => 'invalid type provided',
self::FEED_SIDE_REQUIRED => 'side must be provided for type of Breastfeed',
self::FEED_EXPRESSION_SIDE_REQUIRED => 'side must be provided for type of Expression',
self::FEED_SUBTYPE_REQUIRED => 'subtype must be provided for type of Supplementary',
self::FEED_INVALID_BEFORE_DATE => 'invalid before.date provided',
self::FEED_INVALID_AFTER_DATE => 'invalid after.date provided',
self::FEED_INVALID_DATES => 'after.date must occur after before.date',

self::SAMPLE_SAVE_FAILED => 'failed to insert sample into database',
self::SAMPLE_FETCH_FAILED => 'failed to get feeds from database',
);
*/

enum ClientErrorCode: Int {
    case POSTMethodRequired = 100
    case ActionMissing = 101
    case ActionInvalid = 103
    case UsernameMissing = 104
    case PasswordMissing = 105
    case JSONExpected = 106
    case RequestFormatInvalid = 107
    
    case UserUnknown = 200
    case UserPasswordIncorect = 201
    
    case FeedInvalidType = 300
    case FeedSideRequired = 301
    case FeedExpressionSideRequried = 302
    case FeedSubtypeRequired = 303
    case FeedInvalidBeforeDate = 304
    case FeedInvalidAfterDate = 305
    case FeedInvalidDates = 306
    
    case SampleSaveFailed = 400
    case SampleFetchFailed = 401
    
    var description: String? {
        switch self {
        case .POSTMethodRequired:
            return NSLocalizedString("POST method required", comment: "")
        case .ActionMissing:
            return NSLocalizedString("Missing API action", comment: "")
        case .ActionInvalid:
            return NSLocalizedString("Invalid API action provided", comment: "")
        case .UsernameMissing:
            return NSLocalizedString("Missing API username", comment: "")
        case .PasswordMissing:
            return NSLocalizedString("Missing API password", comment: "")
        case .JSONExpected:
            return NSLocalizedString("API expected JSON to be received", comment: "")
        case .RequestFormatInvalid:
            return NSLocalizedString("The request format received by the API is invalid", comment: "")
            
        case .UserUnknown:
            return NSLocalizedString("The user account for the provided username cannot be found", comment: "")
        case .UserPasswordIncorect:
            return NSLocalizedString("The username and password combination is incorrect", comment: "")
            
        default:
            return nil
        }
    }
}

extension NSError {
    static func ClientError(dictionary: NSDictionary?) -> NSError? {
        let codeNumber = dictionary?.objectForKey("code") as? NSNumber
        let message = dictionary?.objectForKey("message") as? NSString
        
        if codeNumber == nil || message == nil {
            return nil
        }
        
        let codeRawValue = codeNumber!.integerValue
        let code = ClientErrorCode(rawValue: codeRawValue)
        let localizedDescription = code?.description ?? message!
        
        let userInfo: [NSObject : AnyObject] = [ NSLocalizedDescriptionKey : localizedDescription ]
        
        return NSError(domain: Client.ErrorDomain, code: codeRawValue, userInfo: userInfo)
    }
}
