//
//  ASHGameBoardPiece.m
//  Angular
//
//  Created by Ash Furrow on 1/9/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameBoardPieceView.h"
#import <QuartzCore/QuartzCore.h>

// Constants
#define kBlueColor [UIColor colorWithHexString:@"63E4FF"]
#define kRedColor [UIColor colorWithHexString:@"FF4733"]

UIColor *ASHGameBoardPieceViewPlayerAColor;
UIColor *ASHGameBoardPieceViewPlayerBColor;

@implementation ASHGameBoardPieceView

+(void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ASHGameBoardPieceViewPlayerAColor = kBlueColor;
        ASHGameBoardPieceViewPlayerBColor = kRedColor;
    });
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.layer.cornerRadius = CGRectGetMidX(self.bounds);
}

-(void)setPlayer:(ASHGameBoardPositionState)player {
    NSAssert(player != ASHGameBoardPositionStateUndecided, @"Player must exist.");
    _player = player;
    
    if (player == ASHGameBoardPositionStatePlayerA) {
        self.backgroundColor = ASHGameBoardPieceViewPlayerAColor;
    } else {
        self.backgroundColor = ASHGameBoardPieceViewPlayerBColor;
    }
}

-(void)setPlayer:(ASHGameBoardPositionState)player animationDelay:(CGFloat)delay {
    [UIView animateWithDuration:0.2f delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        self.player = player;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)animateBeingAddedWithDelay:(CGFloat)delay {
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(4, 4);
    [UIView animateWithDuration:0.2f delay:delay options:0 animations:^{
        self.alpha = 1.0f;
    } completion:nil];
    [UIView animateWithDuration:0.4f delay:delay options:0 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
