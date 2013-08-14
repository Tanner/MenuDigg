//
//  MDInfoViewController.m
//  MenuDigg
//
//  Created by Tanner Smith on 8/7/13.
//  Copyright (c) 2013 Antarctic Apps. All rights reserved.
//

#import "MDInfoViewController.h"

@interface MDInfoViewController ()

@end

@implementation MDInfoViewController

#define GITHUB_URL @"http://github.com/Tanner/MenuDigg"
#define GITHUB_LINK @"github.com/Tanner/MenuDigg"

@synthesize gitHubURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)awakeFromNib {
    [gitHubURL setAllowsEditingTextAttributes:YES];
    [gitHubURL setSelectable:YES];
    
    NSURL *url = [NSURL URLWithString:GITHUB_URL];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:GITHUB_LINK];
    NSRange range = NSMakeRange(0, [attrString length]);
    
    [attrString beginEditing];
    
    [attrString addAttribute:NSLinkAttributeName value:[url absoluteString] range:range];
    
    // Make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    
    // Make the text appear with an underline
    [attrString addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
    
    [attrString endEditing];
        
    [gitHubURL setAttributedStringValue:attrString];    
}

- (IBAction)gitHubUrlClicked:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:GITHUB_URL];
    
    [[NSWorkspace sharedWorkspace] openURL:url];    
}

@end
