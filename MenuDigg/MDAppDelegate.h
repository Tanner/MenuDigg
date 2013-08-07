//
//  MDAppDelegate.h
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MDAppDelegate : NSObject {
    NSStatusItem *statusItem;
}

@property (assign) IBOutlet NSMenu *statusMenu;

@end
