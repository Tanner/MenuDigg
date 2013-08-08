//
//  MDGeneralPreferencesViewController.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDGeneralPreferencesViewController.h"

@interface MDGeneralPreferencesViewController ()

@end

@implementation MDGeneralPreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)setUpdateInterval:(id)sender {
    NSLog(@"%@", [sender selectedItem]);
}

@end
