//
//  JSMBlockAlertView.m
//  JSMBlockAlertView
//
//  Created by trainer on 30.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSMBlockAlertView.h"

@interface JSMBlockAlertView ()
@property (nonatomic, strong) NSMutableArray *blocks;
@end

@implementation JSMBlockAlertView
@synthesize blocks = _blocks;

- (id) initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    if (self) {
        self.blocks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addButtonWithTitle: (NSString*) title andBlock: (dispatch_block_t) block
{
    if (!block) {
        block = ^{};
    }
    [self addButtonWithTitle:title];
    [self.blocks addObject:[block copy]];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    dispatch_block_t block = [self.blocks objectAtIndex:buttonIndex];
    block ();
}

@end
