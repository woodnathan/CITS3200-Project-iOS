//
//  ViewController.m
//  HHLRG
//
//  Created by Nathan Wood on 12/09/2015.
//  Copyright (c) 2015 Nathan Wood. All rights reserved.
//

#import "HLRViewController.h"
#import "HLRClient.h"

@interface HLRViewController ()

@property (nonatomic, strong) HLRClient *client;

@end

@implementation HLRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    void(^completion)(NSError *) = ^(NSError *error) {
        if ([error.domain isEqual:HLRClientErrorDomain])
        {
            switch (error.code)
            {
                case HLRClientErrorUserUnknown:
                    NSLog(@"Username cannot be found by server");
                    break;
                case HLRClientErrorUserPasswordIncorect:
                    NSLog(@"Password does not match username");
                    break;
                default:
                    NSLog(@"Other: %@", error);
                    break;
            }
        }
        else
        {
            NSLog(@"No error - user authentication successful");
        }
    };
    
    self.client = [[HLRClient alloc] initWithBaseURL:BASE_URL];
    
    // Missing credentials
    self.client.username = nil;
    self.client.password = nil;
    [self.client authenticateWithCompletion:completion];
    
    // Incorrect username
    self.client.username = @"p027";
    self.client.password = @"student";
    [self.client authenticateWithCompletion:completion];
    
    // Incorrect password
    self.client.username = @"p028";
    self.client.password = @"teacher";
    [self.client authenticateWithCompletion:completion];
    
    // Valid credentials
    self.client.username = @"p028";
    self.client.password = @"student";
    [self.client authenticateWithCompletion:completion];
}

@end
