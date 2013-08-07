//
//  MDAppDelegate.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDAppDelegate.h"

@implementation MDAppDelegate

@synthesize statusMenu;
@synthesize separatorMenuItem, preferencesMenuItem, quitMenuItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:NSLocalizedString(@"STATUS_ITEM_TITLE", nil)];
    [statusItem setHighlightMode:YES];
    
    [statusMenu insertItem:[NSMenuItem separatorItem] atIndex:0];
    
    [quitMenuItem setAction:@selector(quit)];
}

- (void)quit {
    [[NSApplication sharedApplication] terminate:nil];
}

@end
