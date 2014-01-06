//
//  ASHGameModel.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameModel.h"
#import "ASHGameBoard.h"
#import "ASHGameBoard+Private.h"

@interface ASHGameModel ()

@property (nonatomic, strong) ASHGameBoard *gameBoard;

@end

@implementation ASHGameModel

-(id)initWithInitialBoard {
    self = [super init];
    if (self == nil) return nil;
    
    self.gameBoard = [[ASHGameBoard alloc] initWithWidth:ASHGameBoardDefaultWidth height:ASHGameBoardDefaultHeight];
    
    [self.gameBoard setState:ASHGameBoardPositionStatePlayerA forPoint:ASHGameBoardPointMake(3, 3)];
    [self.gameBoard setState:ASHGameBoardPositionStatePlayerA forPoint:ASHGameBoardPointMake(4, 4)];
    [self.gameBoard setState:ASHGameBoardPositionStatePlayerB forPoint:ASHGameBoardPointMake(3, 4)];
    [self.gameBoard setState:ASHGameBoardPositionStatePlayerB forPoint:ASHGameBoardPointMake(4, 3)];
    
    return self;
}

-(instancetype)initWithGameBoard:(ASHGameBoard *)gameBoard {
    self = [super init];
    if (self == nil) return nil;
    
    self.gameBoard = [gameBoard copy];
    
    return self;
}

#pragma mark - NSCopying Methods

-(id)copyWithZone:(NSZone *)zone {
    return [[ASHGameModel alloc] initWithGameBoard:self.gameBoard];
}

#pragma mark - Private Methods

-(BOOL)moveIsLegal:(ASHGameBoardPoint)point forPlayer:(ASHGameBoardPositionState)player {
    return NO;
}

#pragma mark - Public Methods

-(ASHGameModel *)makeMove:(ASHGameBoardPoint)point forPlayer:(ASHGameBoardPositionState)player {
    NSAssert(player != ASHGameBoardPositionStateUndecided, @"Move must be made by a player. ");
    //TODO: This. 
    return nil;
}

-(ASHGameModelBoardState)stateOfBoard {
    // TODO: Determine board state
    return ASHGameModelBoardStateUndecided;
}

@end
