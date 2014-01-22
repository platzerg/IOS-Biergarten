//
//  JSMToolbox.m
//  Inventar
//
//  Created by trainer on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSMToolbox.h"

@implementation JSMToolbox

+ (UIImage*) imageWithImage: (UIImage*) image scaledToSize: (CGSize) newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
