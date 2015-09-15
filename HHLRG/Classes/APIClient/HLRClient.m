//
//  HLRClient.m
//  HHLRG
//
//  Created by Nathan Wood on 14/09/2015.
//  Copyright (c) 2015 Nathan Wood. All rights reserved.
//

#import "HLRClient.h"

@interface HLRClient ()

@property (nonatomic, readonly) NSURLSession *session;

@end

@implementation HLRClient

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self)
    {
        self->_baseURL = baseURL;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self->_session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (NSURLRequest *)requestWithAction:(NSString *)action parameters:(id)parameters
{
    static NSString *const APIPath = @"api/api.php?_action=";
    NSString *actionPath = [APIPath stringByAppendingString:action];
    NSURL *URL = [[NSURL alloc] initWithString:actionPath
                                 relativeToURL:self.baseURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:self.username forHTTPHeaderField:@"X-Mother-Username"];
    [request setValue:self.password forHTTPHeaderField:@"X-Mother-Password"];
    
    return request;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(id responseObject, NSError *error))completionHandler
{
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id responseObject = data;

        if (error == nil && [response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
            NSString *contentType = [HTTPResponse.allHeaderFields[@"Content-Type"] lowercaseString];
            if ([contentType isEqualToString:@"application/json"])
            {
                id JSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                                options:0
                                                                  error:&error];
                if (JSONObject)
                    responseObject = JSONObject;
            }
            
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *errorDict = [responseObject objectForKey:@"error"];
                error = HLRClientErrorWithDictionary(errorDict);
            }
        }

        if (completionHandler)
            completionHandler(responseObject, error);
    }];
    [task resume];
    return task;
}

#pragma mark Operations

- (void)authenticateWithCompletion:(HLRClientAuthenticationCompletion)completion
{
    NSURLRequest *request = [self requestWithAction:@"authenticate" parameters:nil];
    [self dataTaskWithRequest:request completionHandler:^(id responseObject, NSError *error) {
        if (completion)
            completion(error);
    }];
}

@end
