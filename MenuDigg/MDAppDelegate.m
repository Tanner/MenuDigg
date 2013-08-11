//
//  MDAppDelegate.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDAppDelegate.h"

#import "MDPreferences.h"
#import "MDPreferencesWindowController.h"
#import "MDDigg.h"

@implementation MDAppDelegate

@synthesize statusMenu;
@synthesize noStoriesMenuItem, separatorMenuItem, refreshMenuItem, preferencesMenuItem, quitMenuItem;

@synthesize preferencesWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDefaultsChanged:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
    NSLog(@"Digg stories: %@", [MDDigg retrieveStories]);
}

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:NSLocalizedString(@"STATUS_ITEM_TITLE", nil)];
    [statusItem setHighlightMode:YES];
        
    [self updateRefreshMenuItem];
}

- (void)userDefaultsChanged:(NSNotification *)notification {
    [self updateRefreshMenuItem];
}

- (void)updateRefreshMenuItem {
    NSInteger updateInterval = [[NSUserDefaults standardUserDefaults] integerForKey:PreferencesUpdateInterval];
    
    [refreshMenuItem setHidden:updateInterval != MANUALLY];
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
