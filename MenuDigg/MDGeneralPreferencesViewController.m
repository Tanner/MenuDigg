//
//  MDGeneralPreferencesViewController.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDGeneralPreferencesViewController.h"

#import "MDPreferences.h"

@interface MDGeneralPreferencesViewController () {
    int lastSelectedUpdateIntervalIndex;
}

@end

@implementation MDGeneralPreferencesViewController

@synthesize updateIntervalMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (IBAction)setUpdateInterval:(id)sender {
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:lastSelectedUpdateIntervalIndex], LAST_UPDATE_INTERVAL_INDEX, nil];
    
    lastSelectedUpdateIntervalIndex = (int) [updateIntervalMenu indexOfSelectedItem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_INTERVAL_CHANGED_NOTIFICATION object:nil userInfo:info];
}

- (IBAction)setNumberOfStories:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NUMBER_STORIES_CHANGED_NOTIFICATION object:nil];
}

@end
