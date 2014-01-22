//
//  JSMBlockAlertView.h
//  JSMBlockAlertView
//
//  Created by trainer on 30.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSMBlockAlertView : UIAlertView <UIAlertViewDelegate>

- (id) initWithTitle:(NSString *)title message:(NSString *)message;
- (void) addButtonWithTitle: (NSString*) title andBlock: (dispatch_block_t) block;

@end
