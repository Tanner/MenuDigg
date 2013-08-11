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

@property (retain) NSString *url;

@property (retain) NSString *content;

- (id)initWithTitle:(NSString *)aTitle kicker:(NSString *)aKicker url:(NSString *)aUrl;

- (NSString *)description;

@end
