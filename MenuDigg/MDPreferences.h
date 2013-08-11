//
//  MDPreferences.h
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _MenuDigg_MDPreferences_H_
#define _MenuDigg_MDPreferences_H_

extern NSString *PreferencesUpdateInterval;
extern NSString *PreferencesStories;

typedef enum updateIntervalTypes {
    EVERY_15 = 0,
    EVERY_30 = 1,
    EVERY_HOUR = 2,
    MANUALLY
} UpdateInterval;

#endif