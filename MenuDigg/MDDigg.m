//
//  MDDigg.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/8/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDDigg.h"

#import "MDDiggStory.h"

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
    
    htmlParserCtxtPtr context = htmlCreatePushParserCtxt(NULL, NULL, NULL, 0, NULL, 0);
    
    xmlCtxtUseOptions(context, XML_PARSE_NOERROR | XML_PARSE_NOWARNING);
    
    htmlDocPtr doc = htmlCtxtReadMemory(context, [data UTF8String], (int) [data length], [DIGG_URL UTF8String], NULL, 0);
    
    NSString *xPathExpression = STORIES_XPATH;
    
    [MDDigg xPathTraverseDocument:doc xPathExpression:xPathExpression withBlock:^(xmlNodePtr node) {
        MDDiggStory *story = [MDDigg extractStoryFromNode:node];
                
        [stories addObject:story];
    }];
        
    xmlFreeDoc(doc);

    // Must reverse the stories as `stories` contains them from bottom-up
    NSMutableArray *reversedStories = [NSMutableArray array];
    
    for (MDDiggStory *story in [stories reverseObjectEnumerator]) {
        [reversedStories addObject:story];
    }
    
    return reversedStories;
}

+ (MDDiggStory *)extractStoryFromNode:(xmlNodePtr)node {
    NSString *title;
    NSString *kicker;
    NSString *url;
    
    for (xmlNodePtr i = node->children; i != NULL; i = i->next) {
        if (xmlStrEqual(i->name, (xmlChar *) "header")) {
            // Probably found <header class="story-header">
            for (xmlNodePtr j = i->children; j != NULL; j = j->next) {
                xmlChar *content = xmlNodeGetContent(j);
                xmlChar *className = xmlGetProp(j, (xmlChar *) "class");
                
                if (xmlStrEqual(j->name, (xmlChar *) "div") && xmlStrEqual(className, (xmlChar *) STORY_KICKER_CLASS)) {
                    // Found <div itemprop="alternative-headline" class="story-kicker">
                    
                    kicker = [[NSString alloc] initWithUTF8String:(char *) content];
                    kicker = [kicker stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                } else if (xmlStrEqual(j->name, (xmlChar * ) "h2") && xmlStrEqual(className, (xmlChar *) STORY_TITLE_CLASS)) {
                    // Found <h2 itemprop="headline" class="story-title entry-title">
                    
                    for (xmlNodePtr k = j->children; k != NULL; k = k->next) {
                        xmlChar *content = xmlNodeGetContent(j);
                        xmlChar *className = xmlGetProp(k, (xmlChar *) "class");
                        xmlChar *href = xmlGetProp(k, (xmlChar *) "href");
                        
                        if (xmlStrEqual(k->name, (xmlChar *) "a") && xmlStrEqual(className, (xmlChar *) STORY_TITLE_LINK_CLASS)) {
                            url = [[NSString alloc] initWithUTF8String:(char *) href];
                            
                            title = [[NSString alloc] initWithUTF8String:(char *) content];
                            title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            
                            break;
                        }
                        
                        xmlFree(content);
                        xmlFree(className);
                        xmlFree(href);
                    }
                }
                
                xmlFree(content);
                xmlFree(className);
            }
        }
    }
    
    return [[MDDiggStory alloc] initWithTitle:title kicker:kicker url:url];
}

+ (void)xPathTraverseDocument:(htmlDocPtr)document xPathExpression:(NSString *)expression withBlock:(void (^)(xmlNodePtr node))block {
    xmlXPathContextPtr xPathContext = xmlXPathNewContext(document);
    
    if (xPathContext == NULL) {
        NSLog(@"Unable to create new XPath context");
                
        return;
    }
    
    xmlXPathObjectPtr xPathObj = xmlXPathEvalExpression((xmlChar *) [expression UTF8String], xPathContext);
    
    if (xPathObj == NULL) {
        NSLog(@"Unable to evaluate xpath expression \"%@\"", expression);
        
        xmlXPathFreeContext(xPathContext);
        
        return;
    }
    
    xmlNodeSetPtr nodes = xPathObj->nodesetval;
    
    int size = nodes ? nodes->nodeNr : 0;
        
    for (int i = 0; i < size; ++i) {
        assert(nodes->nodeTab[i]);
        
        if (nodes->nodeTab[i]->type == XML_ELEMENT_NODE && block != NULL) {
            block(nodes->nodeTab[i]);
        }
    }
    
    xmlXPathFreeObject(xPathObj);
    xmlXPathFreeContext(xPathContext);
}

@end
