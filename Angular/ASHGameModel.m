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
            // state is either friendly or undecided – stop recursion
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
        return 
        [model propagateInDirection:ASHGameBoardPointMake(-1, -1) fromPoint:point initialPoint:point forPlayer:player] ||
        [model propagateInDirection:ASHGameBoardPointMake( 0, -1) fromPoint:point initialPoint:point forPlayer:player] ||
        [model propagateInDirection:ASHGameBoardPointMake( 1, -1) fromPoint:point initialPoint:point forPlayer:player] ||
        [model propagateInDirection:ASHGameBoardPointMake(-1,  0) fromPoint:point initialPoint:point forPlayer:player] ||
        [model propagateInDirection:ASHGameBoardPointMake( 1,  0) fromPoint:point initialPoint:point forPlayer:player] ||
        [model propagateInDirection:ASHGameBoardPointMake(-1,  1) fromPoint:point initialPoint:point forPlayer:player] ||
        [model propagateInDirection:ASHGameBoardPointMake( 0,  1) fromPoint:point initialPoint:point forPlayer:player] ||
        [model propagateInDirection:ASHGameBoardPointMake( 1,  1) fromPoint:point initialPoint:point forPlayer:player];
    }
}

-(BOOL)propagateInAllDirectionsFromPoint:(ASHGameBoardPoint)point forPlayer:(ASHGameBoardPositionState)player {
    // Must do it this way to avoid compiler short-cutting.
    BOOL propagated = NO;
    propagated |= [self propagateInDirection:ASHGameBoardPointMake(-1, -1) fromPoint:point initialPoint:point forPlayer:player];
    propagated |= [self propagateInDirection:ASHGameBoardPointMake( 0, -1) fromPoint:point initialPoint:point forPlayer:player];
    propagated |= [self propagateInDirection:ASHGameBoardPointMake( 1, -1) fromPoint:point initialPoint:point forPlayer:player];
    propagated |= [self propagateInDirection:ASHGameBoardPointMake(-1,  0) fromPoint:point initialPoint:point forPlayer:player];
    propagated |= [self propagateInDirection:ASHGameBoardPointMake( 1,  0) fromPoint:point initialPoint:point forPlayer:player];
    propagated |= [self propagateInDirection:ASHGameBoardPointMake(-1,  1) fromPoint:point initialPoint:point forPlayer:player];
    propagated |= [self propagateInDirection:ASHGameBoardPointMake( 0,  1) fromPoint:point initialPoint:point forPlayer:player];
    propagated |= [self propagateInDirection:ASHGameBoardPointMake( 1,  1) fromPoint:point initialPoint:point forPlayer:player];
    
    if (propagated) {
        [self.gameBoard setState:player forPoint:point];
    }
    
    return propagated;
}

#pragma mark - Public Methods

-(ASHGameModel *)makeMove:(ASHGameBoardPoint)point forPlayer:(ASHGameBoardPositionState)player {
    return [self makeMove:point forPlayer:player force:NO];
}

-(ASHGameModel *)makeMove:(ASHGameBoardPoint)point forPlayer:(ASHGameBoardPositionState)player force:(BOOL)force {
    NSAssert(player != ASHGameBoardPositionStateUndecided, @"Move must be made by a player. ");
    
    BOOL moveIsLegal = NO;
    
    if (force) {
        moveIsLegal = YES;
    } else {
        moveIsLegal = [self moveIsLegal:point forPlayer:player];
    }
    
    if (moveIsLegal == NO) {
        return nil;
    } else {
        ASHGameModel *model = [self copy];
        [model propagateInAllDirectionsFromPoint:point forPlayer:player];
        return model;
    }
}

-(BOOL)playerHasValidMove:(ASHGameBoardPositionState)player {
    BOOL played = NO;
    for (NSUInteger x = 0; x < self.gameBoard.width && played == NO; x++) {
        for (NSUInteger y = 0; y < self.gameBoard.height && played == NO; y++) {
            ASHGameBoardPoint point = ASHGameBoardPointMake(x, y);
            
            ASHGameModel *model = [self copy];
            BOOL success = [model makeMove:point forPlayer:player] != nil;
            
            if (success) {
                played = YES;
            }
        }
    }
    
    return played;
}

-(NSArray *)possibleMovesForPlayer:(ASHGameBoardPositionState)player {
    NSAssert(player != ASHGameBoardPositionStateUndecided, @"Player must exist.");
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (NSUInteger x = 0; x < self.gameBoard.width; x++) {
        for (NSUInteger y = 0; y < self.gameBoard.height; y++) {
            ASHGameBoardPoint point = ASHGameBoardPointMake(x, y);

            BOOL unoccupied = [self.gameBoard stateForPoint:point] == ASHGameBoardPositionStateUndecided;
            
            if (unoccupied) {
                if ([self moveIsLegal:point forPlayer:player]) {
                    [mutableArray addObject:[NSValue valueWithGameBoardPoint:point]];
                }
            }
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

-(ASHGameModelBoardState)stateOfBoard {
    /*
     Game over conditions: 
     - the board is full
     - players A nor B have a valid move
     */
    
    NSUInteger playerACount = 0, playerBCount = 0;
    BOOL boardIsFull = YES;
    for (NSUInteger x = 0; x < self.gameBoard.width; x++) {
        for (NSUInteger y = 0; y < self.gameBoard.height; y++) {
            ASHGameBoardPoint point = ASHGameBoardPointMake(x, y);
            ASHGameBoardPositionState state = [self.gameBoard stateForPoint:point];
            if (state == ASHGameBoardPositionStateUndecided) {
                boardIsFull = NO;
            } else if (state == ASHGameBoardPositionStatePlayerA) {
                playerACount++;
            } else {
                playerBCount++;
            }
        }
    }
    
    BOOL playerHasValidMove = [self playerHasValidMove:ASHGameBoardPositionStatePlayerA] || [self playerHasValidMove:ASHGameBoardPositionStatePlayerB];
    
    if (boardIsFull == YES || playerHasValidMove == NO) {
        if (playerACount > playerBCount) {
            return ASHGameModelBoardStatePlayerA;
        } else if (playerBCount > playerACount) {
            return ASHGameModelBoardStatePlayerB;
        } else {
            return ASHGameModelBoardStateTie;
        }
    } else {
        return ASHGameModelBoardStateUndecided;
    }
}

@end
