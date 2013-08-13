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
    
    [self resizeWindowToView:generalViewController.view];
    [self.view addSubview:generalViewController.view];
}

- (void)showWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];

    [super showWindow:sender];
}

- (void)resizeWindowToView:(NSView *)aView {
    NSRect windowFrame = [self.window contentRectForFrameRect:[self.window frame]];
    NSSize size = aView.frame.size;
    
    NSRect rect = NSMakeRect(NSMinX(windowFrame), NSMaxY(windowFrame) - size.height, size.width, size.height);
    
    NSRect newWindowFrame = [self.window frameRectForContentRect:rect];
    
    [self.window setFrame:newWindowFrame display:YES animate:[self.window isVisible]];
}

- (IBAction)generalToolbarItemClicked:(id)sender {
    [self.view addSubview:generalViewController.view];
    [infoViewController.view removeFromSuperview];
    
    [self resizeWindowToView:generalViewController.view];
}

- (IBAction)infoToolbarItemClicked:(id)sender {    
    [self.view addSubview:infoViewController.view];
    [generalViewController.view removeFromSuperview];
    
    [self resizeWindowToView:infoViewController.view];
}

@end
