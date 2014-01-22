//
//  JSMBlockActionSheet.h
//  JSMBlockActionSheet
//
//  Created by trainer on 30.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSMBlockActionSheet : UIActionSheet <UIActionSheetDelegate>

- (id) initWithTitle:(NSString *)title 
   cancelButtonTitle:(NSString *)cancelButtonTitle 
   cancelButtonBlock:(dispatch_block_t) cancelButtonBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle 
destructiveButtonBlock:(dispatch_block_t) destructiveButtonBlock
   otherButtonsAndBlocks:(NSString *)otherButtonsAndBlocks, ...;

-(void) addButtonsAndBlocksWithArray: (NSArray*) buttonsAndBlocks;

@end
