//
//  MDAppDelegate.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDAppDelegate.h"

#import "MDPreferencesWindowController.h"

@implementation MDAppDelegate

@synthesize statusMenu;
@synthesize separatorMenuItem, preferencesMenuItem, quitMenuItem;

@synthesize preferencesWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:NSLocalizedString(@"STATUS_ITEM_TITLE", nil)];
    [statusItem setHighlightMode:YES];
    
    [statusMenu insertItem:[NSMenuItem separatorItem] atIndex:0];
}

- (IBAction)preferences:(id)sender {
    if (preferencesWindow == nil) {
        preferencesWindow = [[MDPreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
    }
    
    [preferencesWindow showWindow:nil];
    [preferencesWindow.window makeKeyAndOrderFront:self];
}

- (IBAction)quit:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

@end
