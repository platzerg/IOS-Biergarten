//
//  JSMBlockActionSheet.m
//  JSMBlockActionSheet
//
//  Created by trainer on 30.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSMBlockActionSheet.h"

@interface JSMBlockActionSheet ()
@property (nonatomic, strong) NSMutableArray *blocks;
@end

@implementation JSMBlockActionSheet
@synthesize blocks = _blocks;

- (id) initWithTitle:(NSString *)title 
   cancelButtonTitle:(NSString *)cancelButtonTitle 
   cancelButtonBlock:(dispatch_block_t) cancelButtonBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle 
destructiveButtonBlock:(dispatch_block_t) destructiveButtonBlock
otherButtonsAndBlocks:(NSString *)otherButtonsAndBlocks, ...
{
    self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    if (self) {
        self.blocks = [[NSMutableArray alloc] init];

        if (destructiveButtonTitle) {
            if (!destructiveButtonBlock) {
                destructiveButtonBlock = ^{};
            }
            [self.blocks addObject:destructiveButtonBlock];
        }

        if (cancelButtonTitle) {
            if (!cancelButtonBlock) {
                cancelButtonBlock = ^{};
            }
            [self.blocks addObject:cancelButtonBlock];
        }
        
        id eachObject;
        va_list argumentList;
        
        if (otherButtonsAndBlocks) {
            [self addButtonWithTitle:otherButtonsAndBlocks];
            va_start(argumentList, otherButtonsAndBlocks);
            while ((eachObject = va_arg (argumentList, id))) {
                if ([eachObject isKindOfClass:[NSString class]]) {
                    [self addButtonWithTitle: eachObject];
                } else {
                    [self.blocks addObject: [eachObject copy]];
                }
            }
            va_end(argumentList);
        }
    }
    return self;
}

-(void) addButtonsAndBlocksWithArray: (NSArray*) buttonsAndBlocks
{
    for (NSInteger i = 0; i < buttonsAndBlocks.count; i += 2) {
        [self addButtonWithTitle:[buttonsAndBlocks objectAtIndex:i]];
        [self.blocks addObject:[[buttonsAndBlocks objectAtIndex:i + 1] copy]];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    dispatch_block_t block = [self.blocks objectAtIndex:buttonIndex];
    block ();
}

@end
