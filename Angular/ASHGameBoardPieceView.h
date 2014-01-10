//
//  ASHGameBoardPiece.h
//  Angular
//
//  Created by Ash Furrow on 1/9/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASHGameBoardPieceView : UIView

@property (nonatomic, assign) ASHGameBoardPositionState player;

-(void)setPlayer:(ASHGameBoardPositionState)player animationDelay:(CGFloat)delay;
-(void)animateBeingAddedWithDelay:(CGFloat)delay;

@end
