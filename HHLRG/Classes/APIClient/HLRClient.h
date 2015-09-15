//
//  HLRClient.h
//  HHLRG
//
//  Created by Nathan Wood on 14/09/2015.
//  Copyright (c) 2015 Nathan Wood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLRClientError.h"

typedef void(^HLRClientAuthenticationCompletion)(NSError *error);

#if DEBUG
#define BASE_URL_STRING @"http://hhlrg.woodnathan.com/milk/"
#else
#define BASE_URL_STRING @"https://breastfeeding.bcs.uwa.edu.au/milk/"
#endif
#define BASE_URL [NSURL URLWithString:BASE_URL_STRING]

@interface HLRClient : NSObject

- (instancetype)initWithBaseURL:(NSURL *)baseURL;

@property (nonatomic, readonly) NSURL *baseURL;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

- (void)authenticateWithCompletion:(HLRClientAuthenticationCompletion)completion;

@end
