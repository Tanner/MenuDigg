//
//  MDDigg.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/8/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDDigg.h"

#import "MDDiggStory.h"

#import "gumbo.h"

#import "libxml/HTMLparser.h"
#import "libxml/xpath.h"
#import "libxml/tree.h"

@implementation MDDigg

#define DIGG_URL @"http://www.digg.com/"

#define STORIES_XPATH @"//section[@id='top-stories']/article/div[@class='story-content']"

#define STORY_KICKER_CLASS "story-kicker"
#define STORY_TITLE_CLASS "story-title entry-title"
#define STORY_TITLE_LINK_CLASS "story-title-link story-link"

+ (NSArray *)retrieveStories {
    NSMutableArray *stories = [NSMutableArray array];
    
    NSError *error = nil;
    
    NSURL *url = [NSURL URLWithString:DIGG_URL];
    NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];

    if (error) {
        NSLog(@"Error in loading %@: %@", url, error);
        
        return nil;
    }
    
    GumboOutput* output = gumbo_parse([data cStringUsingEncoding:NSUTF8StringEncoding]);
    
//    [MDDigg xPathTraverseDocument:doc xPathExpression:xPathExpression withBlock:^(xmlNodePtr node) {
//        MDDiggStory *story = [MDDigg extractStoryFromNode:node];
//                
//        [stories addObject:story];
//    }];
    
    [MDDigg findStories:output->root];
    
    gumbo_destroy_output(&kGumboDefaultOptions, output);
    
    return stories;
}

+ (NSArray *)findStories:(GumboNode *)node {
    NSDictionary *topStoriesAttribute = [[NSDictionary alloc] initWithObjectsAndKeys:@"top-stories", @"id", nil];
    
    __block NSMutableArray *stories = [[NSMutableArray alloc] init];
    
    [MDDigg findNodesFromNode:node type:GUMBO_NODE_ELEMENT tag:GUMBO_TAG_SECTION attributes:topStoriesAttribute block:^(GumboNode *node, BOOL *stop) {
        // Found the section containg all the stories
        // Find all the stories
        NSLog(@"Found top-stories");
        
        [MDDigg findNodesFromNode:node type:GUMBO_NODE_ELEMENT tag:GUMBO_TAG_ARTICLE attributes:nil block:^(GumboNode *node, BOOL *stop) {
            // Found a story
            // Extract the data from it
            MDDiggStory *story = [MDDigg extractStoryFromNode:node];
            
            if (story != nil) {
                [stories addObject:story];
            } else {
                NSLog(@"Failed to extract story in top-stories");
            }
        }];
        
        *stop = YES;
    }];
    
    return stories;
}

+ (MDDiggStory *)extractStoryFromNode:(GumboNode *)node {
    NSLog(@"Found story");
    
    return nil;
}

+ (void)findNodesFromNode:(GumboNode *)node type:(GumboNodeType)type tag:(GumboTag)tag attributes:(NSDictionary *)attributes block:(void(^)(GumboNode *node, BOOL *stop))block {
    if (node->type != type) {
        return;
    }
    
    BOOL stop = NO;
    
    if (node->v.element.tag == tag) {
        __block BOOL fail = NO;
        
        [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            GumboAttribute *attribute = gumbo_get_attribute(&node->v.element.attributes, [key UTF8String]);
            
            if (attribute != NULL && strcmp(attribute->value, [obj UTF8String]) != 0) {
                fail = YES;
                *stop = YES;
            } else if (attribute == NULL) {
                fail = YES;
                *stop = YES;
            }
        }];
        
        if (fail == NO) {
            block(node, &stop);
        }
    }
    
    if (stop) {
        return;
    }
    
    GumboVector *children = &node->v.element.children;

    for (int i = 0; i < children->length; i++) {
        GumboNode *child = (GumboNode *) children->data[i];
        
        [MDDigg findNodesFromNode:child type:type tag:tag attributes:attributes block:block];
    }
}

//+ (MDDiggStory *)extractStoryFromNode:(xmlNodePtr)node {
//    NSString *title;
//    NSString *kicker;
//    NSString *url;
//    
//    for (xmlNodePtr i = node->children; i != NULL; i = i->next) {
//        if (xmlStrEqual(i->name, (xmlChar *) "header")) {
//            // Probably found <header class="story-header">
//            for (xmlNodePtr j = i->children; j != NULL; j = j->next) {
//                xmlChar *content = xmlNodeGetContent(j);
//                xmlChar *className = xmlGetProp(j, (xmlChar *) "class");
//                
//                if (xmlStrEqual(j->name, (xmlChar *) "div") && xmlStrEqual(className, (xmlChar *) STORY_KICKER_CLASS)) {
//                    // Found <div itemprop="alternative-headline" class="story-kicker">
//                    
//                    kicker = [[NSString alloc] initWithUTF8String:(char *) content];
//                    kicker = [kicker stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                } else if (xmlStrEqual(j->name, (xmlChar * ) "h2") && xmlStrEqual(className, (xmlChar *) STORY_TITLE_CLASS)) {
//                    // Found <h2 itemprop="headline" class="story-title entry-title">
//                    
//                    for (xmlNodePtr k = j->children; k != NULL; k = k->next) {
//                        xmlChar *content = xmlNodeGetContent(j);
//                        xmlChar *className = xmlGetProp(k, (xmlChar *) "class");
//                        xmlChar *href = xmlGetProp(k, (xmlChar *) "href");
//                        
//                        if (xmlStrEqual(k->name, (xmlChar *) "a") && xmlStrEqual(className, (xmlChar *) STORY_TITLE_LINK_CLASS)) {
//                            url = [[NSString alloc] initWithUTF8String:(char *) href];
//                            
//                            title = [[NSString alloc] initWithUTF8String:(char *) content];
//                            title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                            
//                            break;
//                        }
//                        
//                        xmlFree(content);
//                        xmlFree(className);
//                        xmlFree(href);
//                    }
//                }
//                
//                xmlFree(content);
//                xmlFree(className);
//            }
//        }
//    }
//    
//    return [[MDDiggStory alloc] initWithTitle:title kicker:kicker url:url];
//}

@end
