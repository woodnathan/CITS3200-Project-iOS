//
//  HLRClientError.m
//  HHLRG
//
//  Created by Nathan Wood on 15/09/2015.
//  Copyright (c) 2015 Nathan Wood. All rights reserved.
//

#import "HLRClientError.h"

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

NSString *const HLRClientErrorDomain = @"HLRClientErrorDomain";

static NSString *HLRClientErrorLocalizedDescription(HLRClientErrorCode code);

NSError *HLRClientErrorWithDictionary(NSDictionary *dict)
{
    if ([dict isKindOfClass:[NSDictionary class]] == NO)
        return nil;
    
    NSNumber *code = [dict objectForKey:@"code"];
    NSString *message = [dict objectForKey:@"message"];
    
    if (!([code isKindOfClass:[NSNumber class]] && [message isKindOfClass:[NSString class]]))
        return nil;
    
    NSInteger errorCode = [code integerValue];
    NSString *localizedMessage = HLRClientErrorLocalizedDescription(errorCode);
    if (localizedMessage == nil)
        localizedMessage = message;
    
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : localizedMessage };
    
    return [NSError errorWithDomain:HLRClientErrorDomain
                               code:errorCode
                           userInfo:userInfo];
}

NSString *HLRClientErrorLocalizedDescription(HLRClientErrorCode code)
{
    switch (code)
    {
        case HLRClientErrorPOSTMethodRequired:
            return NSLocalizedString(@"POST method required", @"");
        case HLRClientErrorActionMissing:
            return NSLocalizedString(@"Missing API action", @"");
        case HLRClientErrorActionInvalid:
            return NSLocalizedString(@"Invalid API action provided", @"");
        case HLRClientErrorUsernameMissing:
            return NSLocalizedString(@"Missing API username", @"");
        case HLRClientErrorPasswordMissing:
            return NSLocalizedString(@"Missing API password", @"");
        case HLRClientErrorJSONExpected:
            return NSLocalizedString(@"API expected JSON to be received", @"");
        case HLRClientErrorRequestFormatInvalid:
            return NSLocalizedString(@"The request format received by the API is invalid", @"");
        case HLRClientErrorUserUnknown:
            return NSLocalizedString(@"The user account for the provided username cannot be found", @"");
        case HLRClientErrorUserPasswordIncorect:
            return NSLocalizedString(@"The username and password combination is incorrect", @"");
        default:
            break;
    }
    return nil;
}

