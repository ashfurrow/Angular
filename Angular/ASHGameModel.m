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

-(BOOL)propagateInDirection:(ASHGameBoardPoint)vector fromPoint:(ASHGameBoardPoint)point initialPoint:(ASHGameBoardPoint)initialPoint forPlayer:(ASHGameBoardPositionState)player {
    /*
     Propagating: first check if point and initialPoint are the same. If they are, then this is the first invocation of
     the recursion, so point+vector should be an *enemy* tile. Otherwise, stop the recursion when we get outside the
     board (return false), we hit an unnoccupied tile (return false) or we hit a friendly tile (return true).
     */
    
    BOOL firstInvocation = ASHGameBoardPointEqualToPoint(point, initialPoint);
    ASHGameBoardPoint newPoint = ASHGameBoardPointMake(point.x + vector.x, point.y + vector.y);
    BOOL withinBounds = newPoint.x >= 0 && newPoint.y >= 0 && newPoint.x < self.gameBoard.width && newPoint.y < self.gameBoard.height;
    
    ASHGameBoardPositionState enemyState = (player == ASHGameBoardPositionStatePlayerA ? ASHGameBoardPositionStatePlayerB : ASHGameBoardPositionStatePlayerA);
    ASHGameBoardPositionState friendlyState = player;
    
    if (withinBounds == NO) {
        return NO;
    } else if (firstInvocation) {
        ASHGameBoardPositionState actualState = [self.gameBoard stateForPoint:newPoint];
        
        if (actualState == enemyState) {
            // continue recursion
            BOOL success = [self propagateInDirection:vector fromPoint:newPoint initialPoint:initialPoint forPlayer:player];
            if (success) {
                [self.gameBoard setState:friendlyState forPoint:newPoint];
            }
            
            return success;
        } else {
            // stop recursion
            return NO;
        }
    } else {
        ASHGameBoardPositionState actualState = [self.gameBoard stateForPoint:newPoint];
        
        if (actualState == ASHGameBoardPositionStateUndecided) {
            return NO;
        } else if (actualState == friendlyState) {
            return YES;
        } else {
            // continue recursion
            BOOL success = [self propagateInDirection:vector fromPoint:newPoint initialPoint:initialPoint forPlayer:player];
            if (success) {
                [self.gameBoard setState:friendlyState forPoint:newPoint];
            }
            
            return success;
        }
    }
}

-(BOOL)moveIsLegal:(ASHGameBoardPoint)point forPlayer:(ASHGameBoardPositionState)player {
    /*
     Checking for legality of a move: it must be an unnoccupied square and propagating in
     at least one direction must yield a success.
     */
    
    if ([self.gameBoard stateForPoint:point] != ASHGameBoardPositionStateUndecided) {
        return NO;
    } else {
        ASHGameModel *model = [self copy];
        BOOL propagated = [model propagateInAllDirectionsFromPoint:point forPlayer:player];
        
        return propagated;
    }
}

-(BOOL)propagateInAllDirectionsFromPoint:(ASHGameBoardPoint)point forPlayer:(ASHGameBoardPositionState)player {
    BOOL propagated =
    [self propagateInDirection:ASHGameBoardPointMake(-1, -1) fromPoint:point initialPoint:point forPlayer:player] ||
    [self propagateInDirection:ASHGameBoardPointMake( 0, -1) fromPoint:point initialPoint:point forPlayer:player] ||
    [self propagateInDirection:ASHGameBoardPointMake( 1, -1) fromPoint:point initialPoint:point forPlayer:player] ||
    [self propagateInDirection:ASHGameBoardPointMake(-1,  0) fromPoint:point initialPoint:point forPlayer:player] ||
    [self propagateInDirection:ASHGameBoardPointMake( 1,  0) fromPoint:point initialPoint:point forPlayer:player] ||
    [self propagateInDirection:ASHGameBoardPointMake(-1,  1) fromPoint:point initialPoint:point forPlayer:player] ||
    [self propagateInDirection:ASHGameBoardPointMake( 0,  1) fromPoint:point initialPoint:point forPlayer:player] ||
    [self propagateInDirection:ASHGameBoardPointMake( 1,  1) fromPoint:point initialPoint:point forPlayer:player];
    
    if (propagated) {
        [self.gameBoard setState:player forPoint:point];
    }
    
    return propagated;
}

#pragma mark - Public Methods

-(ASHGameModel *)makeMove:(ASHGameBoardPoint)point forPlayer:(ASHGameBoardPositionState)player {
    NSAssert(player != ASHGameBoardPositionStateUndecided, @"Move must be made by a player. ");
    BOOL moveIsLegal = [self moveIsLegal:point forPlayer:player];
    
    if (moveIsLegal == NO) {
        return nil;
    } else {
        ASHGameModel *model = [self copy];
        [model propagateInAllDirectionsFromPoint:point forPlayer:player];
        return model;
    }
}

-(BOOL)playerHasValidMove:(ASHGameBoardPositionState)player {
    return YES;
}

-(ASHGameModelBoardState)stateOfBoard {
    // TODO: Determine board state
    return ASHGameModelBoardStateUndecided;
}

@end
