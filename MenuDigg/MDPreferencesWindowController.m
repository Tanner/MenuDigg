//
//  MDPreferencesWindowController.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDPreferencesWindowController.h"

#import "MDGeneralPreferencesViewController.h"
#import "MDInfoViewController.h"

@interface MDPreferencesWindowController () {
    MDGeneralPreferencesViewController *generalViewController;
    MDInfoViewController *infoViewController;
}
@end

@implementation MDPreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        generalViewController = [[MDGeneralPreferencesViewController alloc] initWithNibName:@"GeneralPreferencesView" bundle:nil];
        
        infoViewController = [[MDInfoViewController alloc] initWithNibName:@"InfoView" bundle:nil];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self.view addSubview:generalViewController.view];
}

- (void)removeAllSubviews {
    [generalViewController.view removeFromSuperview];
    [infoViewController.view removeFromSuperview];
}

- (IBAction)generalToolbarItemClicked:(id)sender {
    [self removeAllSubviews];
    
    [self.view addSubview:generalViewController.view];
}

- (IBAction)infoToolbarItemClicked:(id)sender {
    [self removeAllSubviews];

    [self.view addSubview:infoViewController.view];
}

@end
