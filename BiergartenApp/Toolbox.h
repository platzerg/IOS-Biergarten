//
//  JSMToolbox.h
//  Inventar
//
//  Created by trainer on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSMBadgeLabel.h"
#import "JSMBlockAlertView.h"
#import "JSMBlockActionSheet.h"
#import "JSMCoreDataHelper.h"

@interface JSMToolbox : NSObject

+ (UIImage*) imageWithImage: (UIImage*) image scaledToSize: (CGSize) newSize;

@end
