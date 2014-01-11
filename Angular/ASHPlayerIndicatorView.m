//
//  ASHPlayerIndicatorView.m
//  Angular
//
//  Created by Ash Furrow on 1/11/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHPlayerIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ASHPlayerIndicatorView

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.layer.cornerRadius = CGRectGetMidX(self.bounds);
}

@end
