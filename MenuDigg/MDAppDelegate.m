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
    
    dispatch_queue_t refreshQueue;
    dispatch_source_t timer;
}

@synthesize statusMenu;
@synthesize noStoriesMenuItem, separatorMenuItem, refreshMenuItem, preferencesMenuItem, quitMenuItem;

@synthesize preferencesWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    refreshQueue = dispatch_queue_create("Refresh Queue", DISPATCH_QUEUE_SERIAL);
    
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateIntervalChanged:)
                                                 name:UPDATE_INTERVAL_CHANGED_NOTIFICATION
                                               object:nil];
    
    NSData *storiesData = [[NSUserDefaults standardUserDefaults] objectForKey:PreferencesStories];
    
    if (storiesData != nil) {
        NSLog(@"Loading from stored stories...");
        
        stories = [NSKeyedUnarchiver unarchiveObjectWithData:storiesData];
    }
    
    NSLog(@"Currently have %ld stories", [stories count]);
    
    storyMenuItems = [NSMutableArray array];
    
    [self updateStoryMenuItems];
    [self scheduleRefreshTimer];
}

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
    
    NSImage *statusImage = [NSImage imageNamed:@"icon.png"];
    [statusItem setImage:statusImage];
    
    NSImage *statusAlternateImage = [NSImage imageNamed:@"alternateIcon.png"];
    [statusItem setAlternateImage:statusAlternateImage];
        
    [self updateRefreshMenuItem];
}

- (void)updateIntervalChanged:(NSNotification *)notification {
    [self updateRefreshMenuItem];
    
    [self scheduleRefreshTimer];
}

- (void)refreshStories {
    NSLog(@"Retrieving fresh stories...");
    
    stories = [MDDigg retrieveStories];
    
    NSLog(@"Retrieved %ld stories", [stories count]);
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:stories];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:PreferencesStories];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (int)refreshTime {
    NSInteger updateInterval = [[NSUserDefaults standardUserDefaults] integerForKey:PreferencesUpdateInterval];
    
    switch (updateInterval) {
        case EVERY_15:
            return 60 * 15;
            break;
        case EVERY_30:
            return 60 * 30;
            break;
        case EVERY_HOUR:
            return 60 * 60;
            break;
        case MANUALLY:
        default:
            return -1;
    }
}

- (void)scheduleRefreshTimer {
    int time = [self refreshTime];
    
    if (timer != nil) {
        NSLog(@"Cancelling existing timer");
        
        dispatch_source_cancel(timer);
    }
    
    if (time <= 0) {
        return;
    }
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, refreshQueue);
    
    NSLog(@"Scheduling next refresh in %d seconds", time);

    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), time * NSEC_PER_SEC, 60 * 5 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"Refreshing stories from periodic timer...");

        [self refreshStories];
        [self updateStoryMenuItems];        
    });
    
    dispatch_resume(timer);
}

- (void)storyMenuItemClicked:(id)sender {
    NSMenuItem *item = (NSMenuItem *) sender;
    MDDiggStory *story = [item representedObject];
    
    NSURL *url = [[NSURL alloc] initWithString:[story url]];
    
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)refresh:(id)sender {
    [self refreshStories];
    [self updateStoryMenuItems];
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
