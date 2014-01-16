//
//  ASHPlayerIndicatorView.m
//  Angular
//
//  Created by Ash Furrow on 1/11/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHPlayerIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@interface ASHPlayerIndicatorView ()

@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation ASHPlayerIndicatorView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = [UIColor colorWithHexString:@"FFB759"];
    [self addSubview:self.indicatorView];
    [self updateForFrame];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateForFrame];
}

-(void)updateForFrame {
    self.layer.cornerRadius = CGRectGetMidX(self.bounds);
    self.indicatorView.frame = CGRectInset(self.bounds, 30, 30);
    self.indicatorView.layer.cornerRadius = CGRectGetMidX(self.indicatorView.bounds);
}

-(void)setActive:(BOOL)active {
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:0 animations:^{
        if (active) {
            self.indicatorView.transform = CGAffineTransformIdentity;
        } else {
            self.indicatorView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        }
    } completion:nil];
}

@end
