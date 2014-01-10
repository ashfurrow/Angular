//
//  ASHGameBoardViewModel.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "RVMViewModel.h"

typedef NS_ENUM(NSUInteger, ASHGameBoardViewModelPlayer) {
    ASHGameBoardViewModelPlayerA = 0,
    ASHGameBoardViewModelPlayerB
};

ASHGameBoardPositionState stateForPlayer(ASHGameBoardViewModelPlayer player);

@interface ASHGameBoardViewModel : RVMViewModel

@property (nonatomic, readonly) NSUInteger gameBoardWidth;
@property (nonatomic, readonly) NSUInteger gameBoardHeight;
@property (nonatomic, readonly) ASHGameBoardViewModelPlayer player;
@property (nonatomic, readonly) RACSignal *gameBoardUpdatedSignal;
@property (nonatomic, readonly) RACSignal *computerIsThinkingSignal;
@property (nonatomic, readonly) RACSignal *gameOverSignal;

-(ASHGameBoardPositionState)stateForPoint:(ASHGameBoardPoint)point;
-(BOOL)makePlay:(ASHGameBoardPoint)point;
-(void)newGame;

@end
