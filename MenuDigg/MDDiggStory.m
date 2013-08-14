//
//  MDDiggStory.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/11/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDDiggStory.h"

@implementation MDDiggStory

@synthesize title, kicker, desc, url;
@synthesize diggs, tweets, facebookShares, diggScore;

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
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:kicker forKey:@"kicker"];
    [aCoder encodeObject:url forKey:@"url"];
}


- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[MDDiggStory class]]) {
        MDDiggStory *story = (MDDiggStory *) object;
        
        return [[story title] isEqualToString:title] &&
        [[story kicker] isEqualToString:kicker] &&
        [[story url] isEqualToString:url];
    }
    
    return NO;
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"%@ (%@) at %@", title, kicker, url];
}

@end
