//
//  ASHGameBoardViewModel.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameBoardViewModel.h"

#import "ASHGameBoard.h"

@interface ASHGameBoardViewModel ()

// Private Properties
@property (nonatomic, strong) ASHGameBoard *gameBoard;

// Private Access
@property (nonatomic, assign) NSUInteger gameBoardWidth;
@property (nonatomic, assign) NSUInteger gameBoardHeight;
@property (nonatomic, assign) ASHGameBoardViewModelPlayer player;

@end

@implementation ASHGameBoardViewModel

-(instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    
    self.gameBoard = [[ASHGameBoard alloc] initWithWidth:ASHGameBoardDefaultWidth height:ASHGameBoardDefaultHeight];
    
    self.gameBoardWidth = self.gameBoard.width;
    self.gameBoardHeight = self.gameBoard.height;
    
    [self setupInitialBoard];
    
    return self;
}

#pragma mark - Private Methods

-(void)setupInitialBoard {
    [self.gameBoard setState:ASHGameBoardPositionStatePlayerA forPoint:ASHGameBoardPointMake(3, 3)];
    [self.gameBoard setState:ASHGameBoardPositionStatePlayerA forPoint:ASHGameBoardPointMake(4, 4)];
    [self.gameBoard setState:ASHGameBoardPositionStatePlayerB forPoint:ASHGameBoardPointMake(3, 4)];
    [self.gameBoard setState:ASHGameBoardPositionStatePlayerB forPoint:ASHGameBoardPointMake(4, 3)];
}

#pragma mark - Public Methods

-(ASHGameBoardPositionState)stateForPoint:(ASHGameBoardPoint)point {
    return [self.gameBoard stateForPoint:point];
} 

-(void)switchPlayer {
    self.player = !self.player;
}

@end
