//
//  ViewController.m
//  ContactDemo
//
//  Created by Thanh-Phong Tran on 2/16/17.
//  Copyright © 2017 Thanh-Phong Tran. All rights reserved.
//

#import "ViewController.h"
@import Contacts;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self addContacts];
    });
}


- (void) addContacts {
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // user didn't grant access;
                // so, again, tell user here why app needs permissions in order  to do it's job;
                // this is dispatched to the main queue because this request could be running on background thread
            });
            return;
        }
        
        // create contact
        
        
        for (int i = 0; i < 100; i++) {
            CNMutableContact *contact = [[CNMutableContact alloc] init];
            contact.givenName = [NSString stringWithFormat:@"%@ %d", @"Test", i];
            
            CNSaveRequest *request = [[CNSaveRequest alloc] init];
            [request addContact:contact toContainerWithIdentifier:nil];
            
            // save it
            
            NSError *saveError;
            if (![store executeSaveRequest:request error:&saveError]) {
                NSLog(@"error = %@", saveError);
            }
            
            NSLog(@"Added %d", i);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
