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
@property (nonatomic, strong) RACSubject *gameBoardUpdatedSignal;
@property (nonatomic, strong) RACSubject *gameOverSignal;

@end

@implementation ASHGameBoardViewModel

-(instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    
    self.gameBoard = [[ASHGameBoard alloc] initWithWidth:ASHGameBoardDefaultWidth height:ASHGameBoardDefaultHeight];
    
    self.gameBoardWidth = self.gameBoard.width;
    self.gameBoardHeight = self.gameBoard.height;
    
    @weakify(self);
    self.gameBoardUpdatedSignal = [RACSubject subject];
    [self.gameBoardUpdatedSignal subscribeNext:^(id x) {
        @strongify(self);
        
        if (self.player == ASHGameBoardViewModelPlayerB) {
            [self makeAIMove];
        }
        
        [self checkForWin];
    }];
    
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

-(void)switchPlayer {
    self.player = !self.player;
}

-(void)makeAIMove {
    // Stupid AI for now
    // TODO: Write smarter AI
    BOOL played = NO;
    for (NSUInteger x = 0; x < self.gameBoardWidth && played == NO; x++) {
        for (NSUInteger y = 0; y < self.gameBoardHeight && played == NO; y++) {
            ASHGameBoardPoint point = ASHGameBoardPointMake(x, y);
            if ([self playIsLegalForCurrentPlayer:point]) {
                [self makePlay:point];
                played = YES;
            }
        }
    }
}

-(BOOL)playIsLegalForCurrentPlayer:(ASHGameBoardPoint)point {
    BOOL valid = YES;
    
    ASHGameBoardPositionState state = [self.gameBoard stateForPoint:point];
    if (state != ASHGameBoardPositionStateUndecided) {
        valid = NO;
    } else {
        // Check for adjacent blocks in all directions
        if (![self direction:ASHGameBoardPointMake(-1, -1) point:point changesBoardForPlayer:self.player set:NO] &&
            ![self direction:ASHGameBoardPointMake(0, -1) point:point changesBoardForPlayer:self.player set:NO] &&
            ![self direction:ASHGameBoardPointMake(1, -1) point:point changesBoardForPlayer:self.player set:NO] &&
            ![self direction:ASHGameBoardPointMake(-1, 0) point:point changesBoardForPlayer:self.player set:NO] &&
            ![self direction:ASHGameBoardPointMake(1, 0) point:point changesBoardForPlayer:self.player set:NO] &&
            ![self direction:ASHGameBoardPointMake(-1, 1) point:point changesBoardForPlayer:self.player set:NO] &&
            ![self direction:ASHGameBoardPointMake(0, 1) point:point changesBoardForPlayer:self.player set:NO] &&
            ![self direction:ASHGameBoardPointMake(1, 1) point:point changesBoardForPlayer:self.player set:NO]) {
            valid = NO;
        }
    }
    
    return valid;
}

-(BOOL)direction:(ASHGameBoardPoint)vector point:(ASHGameBoardPoint)point changesBoardForPlayer:(ASHGameBoardViewModelPlayer)player set:(BOOL)set {
    // Initial requirement: point + vector must be within the board and be the player's token
    NSInteger newPointX = vector.x + point.x;
    NSInteger newPointY = vector.y + point.y;
    if (newPointX < 0 || newPointX >= self.gameBoardWidth ||
        newPointY < 0 || newPointY >= self.gameBoardHeight) {
        return NO;
    } else {
        ASHGameBoardPoint newPoint = ASHGameBoardPointMake(newPointX, newPointY);
        
        ASHGameBoardPositionState opponentTile = (player == ASHGameBoardViewModelPlayerA ? ASHGameBoardPositionStatePlayerB : ASHGameBoardPositionStatePlayerA);
        ASHGameBoardPositionState actualState = [self stateForPoint:newPoint];
        
        if (actualState == opponentTile) {
            if ([self recursiveDirection:vector point:newPoint changesBoardForPlayer:player set:set]) {
                if (set) {
                    ASHGameBoardPositionState desiredState = (player == ASHGameBoardViewModelPlayerA ? ASHGameBoardPositionStatePlayerA : ASHGameBoardPositionStatePlayerB);
                    [self.gameBoard setState:desiredState forPoint:newPoint];
                }
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    }
}

-(BOOL)recursiveDirection:(ASHGameBoardPoint)vector point:(ASHGameBoardPoint)point changesBoardForPlayer:(ASHGameBoardViewModelPlayer)player set:(BOOL)set {
    
    // Initial requirement: point + vector must be within the board and be the player's token
    NSInteger newPointX = vector.x + point.x;
    NSInteger newPointY = vector.y + point.y;
    if (newPointX < 0 || newPointX >= self.gameBoardWidth ||
        newPointY < 0 || newPointY >= self.gameBoardHeight) {
        return NO;
    } else {
        ASHGameBoardPoint newPoint = ASHGameBoardPointMake(newPointX, newPointY);
        ASHGameBoardPositionState desiredState = (player == ASHGameBoardViewModelPlayerA ? ASHGameBoardPositionStatePlayerA : ASHGameBoardPositionStatePlayerB);
        ASHGameBoardPositionState actualState = [self stateForPoint:newPoint];
        
        if (actualState == desiredState) {
            // We're done recursing
            return YES;
        } else if (actualState == ASHGameBoardPositionStateUndecided) {
            return NO;
        } else {
            if ([self recursiveDirection:vector point:newPoint changesBoardForPlayer:player set:set]) {
                if (set) {
                    [self.gameBoard setState:desiredState forPoint:newPoint];
                }
                return YES;
            } else {
                return NO;
            }
        }
    }
}

-(void)changeInAllDirections:(ASHGameBoardViewModelPlayer)player point:(ASHGameBoardPoint)point {
    [self direction:ASHGameBoardPointMake(-1, -1) point:point changesBoardForPlayer:player set:YES];
    [self direction:ASHGameBoardPointMake(0, -1) point:point changesBoardForPlayer:player set:YES];
    [self direction:ASHGameBoardPointMake(1, -1) point:point changesBoardForPlayer:player set:YES];
    [self direction:ASHGameBoardPointMake(-1, 0) point:point changesBoardForPlayer:player set:YES];
    [self direction:ASHGameBoardPointMake(1, 0) point:point changesBoardForPlayer:player set:YES];
    [self direction:ASHGameBoardPointMake(-1, 1) point:point changesBoardForPlayer:player set:YES];
    [self direction:ASHGameBoardPointMake(0, 1) point:point changesBoardForPlayer:player set:YES];
    [self direction:ASHGameBoardPointMake(1, 1) point:point changesBoardForPlayer:player set:YES];
}

-(void)checkForWin {
    ASHGameBoardPositionState state = ASHGameBoardPositionStateUndecided;
    
    // TODO: Check for win
    
    if (state != ASHGameBoardPositionStateUndecided) {
        [(RACSubject *)self.gameOverSignal sendNext:@(state)];
        [(RACSubject *)self.gameOverSignal sendCompleted];
    }
}

#pragma mark - Public Methods

-(ASHGameBoardPositionState)stateForPoint:(ASHGameBoardPoint)point {
    return [self.gameBoard stateForPoint:point];
} 

-(BOOL)makePlay:(ASHGameBoardPoint)point {
    BOOL valid = [self playIsLegalForCurrentPlayer:point];
    
    if (valid) {
        ASHGameBoardPositionState state = ASHGameBoardPositionStateUndecided;
        
        switch (self.player) {
            case ASHGameBoardViewModelPlayerA:
                state = ASHGameBoardPositionStatePlayerA;
                break;
            case ASHGameBoardViewModelPlayerB:
                state = ASHGameBoardPositionStatePlayerB;
                break;
        }
        
        [self.gameBoard setState:state forPoint:point];
        [self changeInAllDirections:self.player point:point];
        [self switchPlayer];
        [(RACSubject *)self.gameBoardUpdatedSignal sendNext:nil];
    }
    
    return valid;
}

@end
