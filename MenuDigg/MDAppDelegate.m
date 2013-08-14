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
    
    NSImage *statusImage;
    NSImage *newStoriesImage;
    
    dispatch_queue_t refreshQueue;
    dispatch_source_t timer;
}

@synthesize statusMenu;
@synthesize noStoriesMenuItem, separatorMenuItem, refreshMenuItem, preferencesMenuItem, quitMenuItem;

@synthesize preferencesWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    refreshQueue = dispatch_queue_create("Refresh Queue", DISPATCH_QUEUE_SERIAL);

    // Register the default defaults if they don't exist
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateIntervalChanged:)
                                                 name:UPDATE_INTERVAL_CHANGED_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStoryMenuItems)
                                                 name:NUMBER_STORIES_CHANGED_NOTIFICATION
                                               object:nil];
    
    // Load (if necessary) and put the stories in the status bar menu
    NSData *storiesData = [[NSUserDefaults standardUserDefaults] objectForKey:PreferencesStories];
    
    NSDate *lastUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:PreferencesLastUpdateDate];
    int refreshTime = [self refreshTime];
    
    if (refreshTime > 0 && (lastUpdateDate == nil || [lastUpdateDate timeIntervalSinceNow] > refreshTime)) {
        storiesData = nil;
    }
    
    if (storiesData != nil) {
        NSLog(@"Loading from stored stories...");
        
        stories = [NSKeyedUnarchiver unarchiveObjectWithData:storiesData];
    } else {
        [self refreshStories];
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
    
    statusImage = [NSImage imageNamed:@"icon.png"];
    newStoriesImage = [NSImage imageNamed:@"newStoriesIcon.png"];
    
    NSImage *statusAlternateImage = [NSImage imageNamed:@"alternateIcon.png"];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusAlternateImage];
    
    [statusItem setDoubleAction:@selector(statusMenuClicked)];
    
    [self updateRefreshMenuItem];
}

# pragma mark -
# pragma mark Refresh / Update Interval

- (void)updateIntervalChanged:(NSNotification *)notification {
    [self updateRefreshMenuItem];
    
    // Cancel the timer and reschedule a new one with the new time
    [self scheduleRefreshTimer];
}

- (void)refreshStories {
    NSLog(@"Retrieving fresh stories...");
    
    NSArray *newStories = [MDDigg retrieveStories];
    
    if (stories != nil && [newStories isEqualToArray:stories] == NO) {
        [statusItem setImage:newStoriesImage];
    }
    
    stories = newStories;
    
    NSLog(@"Retrieved %ld stories", [stories count]);
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:stories];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:PreferencesStories];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:PreferencesLastUpdateDate];
    
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
    
    NSInteger numberOfStories = [self numberOfStories];
    
    for (NSInteger i = numberOfStories; i >= 0; i--) {
        MDDiggStory *story = [stories objectAtIndex:i];
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

- (NSInteger)numberOfStories {
    NSInteger numberOfStories = [[NSUserDefaults standardUserDefaults] integerForKey:PreferencesNumberOfStories];
    
    switch (numberOfStories) {
        case FIVE_STORIES:
            return 5;
            break;
        case TEN_STORIES:
            return 10;
            break;
        case FIFTHTEEN_STORIES:
            return 15;
            break;
        case ALL_STORIES:
        default:
            return [stories count];
    }
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
    
    dispatch_time_t startTime = dispatch_time(dispatch_walltime(NULL, 0), time * NSEC_PER_SEC);
    
    dispatch_source_set_timer(timer, startTime, time * NSEC_PER_SEC, 60 * 5 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"Refreshing stories from periodic timer...");
        
        [self refreshStories];
        [self updateStoryMenuItems];
    });
    
    dispatch_resume(timer);
}

# pragma mark -
# pragma mark NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu {
    if ([statusItem image] == newStoriesImage) {
        [statusItem setImage:statusImage];
    }
}

# pragma mark -
# pragma mark Menu Item Handlers

- (void)storyMenuItemClicked:(id)sender {
    // Open the story in the user's browser!
    NSMenuItem *item = (NSMenuItem *) sender;
    MDDiggStory *story = [item representedObject];
    
    NSURL *url = [[NSURL alloc] initWithString:[story url]];
    
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)refresh:(id)sender {
    dispatch_async(refreshQueue, ^{
        [self refreshStories];
        [self updateStoryMenuItems];
    });
}

- (IBAction)preferences:(id)sender {
    if (preferencesWindow == nil) {
        preferencesWindow = [[MDPreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
    }
    
    [preferencesWindow showWindow:self];
}

- (IBAction)quit:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

@end
