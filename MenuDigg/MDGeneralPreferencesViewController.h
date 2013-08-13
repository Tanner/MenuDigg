//
//  MDGeneralPreferencesViewController.h
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MDGeneralPreferencesViewController : NSViewController

#define UPDATE_INTERVAL_CHANGED_NOTIFICATION @"UpdateIntervalChanged"
#define NUMBER_STORIES_CHANGED_NOTIFICATION @"NumberOfStoriesChanged"

#define LAST_UPDATE_INTERVAL_INDEX @"LastUpdateIntervalIndex"

@property (assign) IBOutlet NSPopUpButton *updateIntervalMenu;
@property (assign) IBOutlet NSPopUpButton *numberOfStoriesMenu;

- (IBAction)setUpdateInterval:(id)sender;
- (IBAction)setNumberOfStories:(id)sender;

@end
