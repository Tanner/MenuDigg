//
//  MDDiggStory.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/11/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDDiggStory.h"

@implementation MDDiggStory

@synthesize title, kicker, url, content;

- (id)initWithTitle:(NSString *)aTitle kicker:(NSString *)aKicker url:(NSString *)aUrl {
    if (self = [self init]) {
        title = aTitle;
        kicker = aKicker;
        url = aUrl;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        title = [aDecoder decodeObjectForKey:@"title"];
        kicker = [aDecoder decodeObjectForKey:@"kicker"];
        url = [aDecoder decodeObjectForKey:@"url"];
        content = [aDecoder decodeObjectForKey:@"content"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:kicker forKey:@"kicker"];
    [aCoder encodeObject:url forKey:@"url"];
    [aCoder encodeObject:content forKey:@"content"];
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"%@ (%@) at %@", title, kicker, url];
}

@end
