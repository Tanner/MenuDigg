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
#import "MDDiggStory.h"

@implementation MDAppDelegate {
    NSArray *stories;
    
    NSMutableArray *storyMenuItems;
}

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
    
    NSData *storiesData = [[NSUserDefaults standardUserDefaults] objectForKey:PreferencesStories];
    
    if (storiesData == nil) {
        NSLog(@"No stored stories found, retrieving fresh stories...");
        
        stories = [MDDigg retrieveStories];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:stories];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:PreferencesStories];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Loading from stored stories...");
        
        stories = [NSKeyedUnarchiver unarchiveObjectWithData:storiesData];
    }
    
    NSLog(@"Currently have %ld stories: %@", [stories count], stories);
    
    storyMenuItems = [NSMutableArray array];
    
    [self updateStoryMenuItems];
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

- (void)updateStoryMenuItems {
    [noStoriesMenuItem setHidden:[stories count] > 0];
    
    if ([storyMenuItems count] > 0) {
        for (NSMenuItem *item in storyMenuItems) {
            [statusMenu removeItem:item];
        }
    }
    
    [storyMenuItems removeAllObjects];
    
    for (MDDiggStory *story in stories) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[story title] action:@selector(storyMenuItemClicked:) keyEquivalent:@""];
        
        [item setToolTip:[story kicker]];
        [item setRepresentedObject:story];
        
        [statusMenu insertItem:item atIndex: 0];
        
        [storyMenuItems addObject:item];
    }
}

- (void)updateRefreshMenuItem {
    NSInteger updateInterval = [[NSUserDefaults standardUserDefaults] integerForKey:PreferencesUpdateInterval];
    
    [refreshMenuItem setHidden:updateInterval != MANUALLY];
}

- (void)storyMenuItemClicked:(id)sender {
    NSMenuItem *item = (NSMenuItem *) sender;
    MDDiggStory *story = [item representedObject];
    
    NSURL *url = [[NSURL alloc] initWithString:[story url]];
    
    [[NSWorkspace sharedWorkspace] openURL:url];
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
