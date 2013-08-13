//
//  MDInfoViewController.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDInfoViewController.h"

@interface MDInfoViewController ()

@end

@implementation MDInfoViewController

#define GITHUB_URL @"http://github.com/Tanner/MenuDigg"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (IBAction)gitHubUrlClicked:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:GITHUB_URL];
    
    [[NSWorkspace sharedWorkspace] openURL:url];    
}

@end
