//
//  ViewController.m
//  Auth
//
//  Created by Josh Sephton on 16/08/2014.
//  Copyright (c) 2014 Springa Ltd. All rights reserved.
//

#import "ViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import "KeychainItemWrapper.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)authenticateButtonTapped:(id)sender
{
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
    
    // To save into Keychain
    [keychainItem setObject:@"Adhith password" forKey:(__bridge id)kSecValueData];
    [keychainItem setObject:@"Adhith username" forKey:(__bridge id)kSecAttrAccount];
    
    // To get from keychain
    NSString *password = [keychainItem objectForKey:(__bridge id)kSecValueData];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    //[keychainItem resetKeychainItem];
    NSLog(@"%@",username);
    NSLog(@"%@",password);
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"There was a problem verifying your identity."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            if(success){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"You are the device owner!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"You are not the device owner."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
