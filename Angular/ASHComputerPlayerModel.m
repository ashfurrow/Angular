//
//  ASHComputerPlayerModel.m
//  Angular
//
//  Created by Ash Furrow on 1/8/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHComputerPlayerModel.h"

// Models
#import "ASHGameBoard.h"
#import "ASHGameModel.h"
#import "ASHGameBoardViewModel.h"

@interface ASHComputerPlayerModel ()

@property (nonatomic, strong) ASHGameModel *gameModel;

@end

@implementation ASHComputerPlayerModel

#pragma mark - Initializers

-(instancetype)initWithGameModel:(ASHGameModel *)gameModel {
    self = [super init];
    if (self == nil) return nil;
    
    self.gameModel = gameModel;
    
    return self;
}

#pragma mark - Public Methods

-(ASHGameBoardPoint)bestMoveForPlayer:(ASHGameBoardPositionState)player {
    NSAssert(player != ASHGameBoardPositionStateUndecided, @"Player must exist.");
    
    NSArray *possibleMoves = [self.gameModel possibleMovesForPlayer:player];
    NSValue *playValue = [possibleMoves firstObject];
    ASHGameBoardPoint play = [playValue gameBoardPointValue];
    
    return play;
}

@end
