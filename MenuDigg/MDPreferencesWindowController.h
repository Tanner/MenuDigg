//
//  MDPreferencesWindowController.h
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MDGeneralPreferencesViewController.h"

@interface MDPreferencesWindowController : NSWindowController

@property (assign) IBOutlet NSToolbar *toolbar;

@property (assign) IBOutlet NSToolbarItem *general;
@property (assign) IBOutlet NSToolbarItem *info;

@property (assign) IBOutlet NSView *view;

- (IBAction)generalToolbarItemClicked:(id)sender;
- (IBAction)infoToolbarItemClicked:(id)sender;

@end
