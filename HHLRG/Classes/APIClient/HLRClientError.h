//
//  HLRClientError.h
//  HHLRG
//
//  Created by Nathan Wood on 15/09/2015.
//  Copyright (c) 2015 Nathan Wood. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const HLRClientErrorDomain;

typedef NS_ENUM(NSInteger, HLRClientErrorCode) {
    HLRClientErrorPOSTMethodRequired = 100,
    HLRClientErrorActionMissing = 101,
    HLRClientErrorActionInvalid = 103,
    HLRClientErrorUsernameMissing = 104,
    HLRClientErrorPasswordMissing = 105,
    HLRClientErrorJSONExpected = 106,
    HLRClientErrorRequestFormatInvalid = 107,
    
    HLRClientErrorUserUnknown = 200,
    HLRClientErrorUserPasswordIncorect = 201,
    
    HLRClientErrorFeedInvalidType = 300,
    HLRClientErrorFeedSideRequired = 301,
    HLRClientErrorFeedExpressionSideRequried = 302,
    HLRClientErrorFeedSubtypeRequired = 303,
    HLRClientErrorFeedInvalidBeforeDate = 304,
    HLRClientErrorFeedInvalidAfterDate = 305,
    HLRClientErrorFeedInvalidDates = 306,
    
    HLRClientErrorSampleSaveFailed = 400,
    HLRClientErrorSampleFetchFailed = 401,
};

extern NSError *HLRClientErrorWithDictionary(NSDictionary *dict);
