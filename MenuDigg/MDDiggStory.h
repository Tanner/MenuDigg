//
//  MDDiggStory.h
//  MenuDigg
//
//  Created by Tanner Smith on 8/11/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDiggStory : NSObject <NSCoding>

@property (retain) NSString *title;
@property (retain) NSString *kicker;
@property (retain) NSString *desc;

@property (retain) NSString *url;

@property (assign) int diggs;
@property (assign) int tweets;
@property (assign) int facebookShares;
@property (assign) int diggScore;

- (id)initWithTitle:(NSString *)aTitle kicker:(NSString *)aKicker url:(NSString *)aUrl;

- (NSString *)description;

@end
