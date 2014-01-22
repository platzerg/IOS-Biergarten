//
//  JSMBadgeLabel.m
//  JSMBadgeView
//
//  Created by trainer on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JSMBadgeLabel.h"

@interface JSMBadgeLabel ()
- (void) setup;
@end

@implementation JSMBadgeLabel
@synthesize targetUIView = _targetUIView;

- (void) setup 
{
    self.textAlignment = UITextAlignmentCenter;
    self.layer.cornerRadius = self.font.pointSize * 0.8;
}

-(void)awakeFromNib
{
    [self setup];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    CGSize size = [text sizeWithFont:self.font];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 
                            size.width + self.font.pointSize * 0.8, size.height);
    
    CGRect badgeFrame = self.frame;
    CGRect targetFrame = self.targetUIView.frame;
    
    self.frame = CGRectMake(targetFrame.origin.x + targetFrame.size.width - badgeFrame.size.width / 2, 
                            targetFrame.origin.y - badgeFrame.size.height / 2, 
                            badgeFrame.size.width, badgeFrame.size.height);
}
@end
