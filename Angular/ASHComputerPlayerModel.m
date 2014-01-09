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
    
//    (* Initial call *)
//    alphabeta(origin, depth, -∞, +∞, TRUE)
    NSInteger score = [ASHComputerPlayerModel alphaBeta:self.gameModel depth:5 alpha:NSIntegerMin beta:NSIntegerMax maximisingPlayer:player initialPlay:ASHGameBoardPointNull initialPlayer:player];
    NSLog(@"Best score is %d", score);
    
    return play;
}

#pragma mark - Private Methods

/*
 From: http://en.wikipedia.org/wiki/Alpha-beta_pruning
function alphabeta(node, depth, α, β, maximizingPlayer)
    if depth = 0 or node is a terminal node
        return the heuristic value of node
    if maximizingPlayer
        for each child of node
            α := max(α, alphabeta(child, depth - 1, α, β, FALSE))
            if β ≤ α
                break (* β cut-off *)
        return α
    else
        for each child of node
            β := min(β, alphabeta(child, depth - 1, α, β, TRUE))
            if β ≤ α
                break (* α cut-off *)
        return β
*/
+(NSInteger)alphaBeta:(ASHGameModel *)gameModel depth:(NSInteger)depth alpha:(NSInteger)alpha beta:(NSInteger)beta maximisingPlayer:(ASHGameBoardPositionState)player initialPlay:(ASHGameBoardPoint)startingPlay initialPlayer:(ASHGameBoardPositionState)initialPlayer {
    NSArray *possibleMoves = [gameModel possibleMovesForPlayer:player];
    if (depth == 0 || possibleMoves.count == 0) {
        return [self scoreForGameModel:gameModel player:initialPlayer];
    }
    if (player == ASHGameBoardPositionStatePlayerA) {
        for (NSValue *move in possibleMoves) {
            ASHGameModel *model = [gameModel copy];
            ASHGameBoardPoint initialPlay = startingPlay;
            if (ASHGameBoardPointEqualToPoint(initialPlay, ASHGameBoardPointNull)) {
                initialPlay = move.gameBoardPointValue;
            }
            
            [model makeMove:move.gameBoardPointValue forPlayer:player];
            alpha = MAX(alpha, [self alphaBeta:model depth:depth-1 alpha:alpha beta:beta maximisingPlayer:ASHGameBoardPositionStatePlayerB initialPlay:initialPlay initialPlayer:initialPlayer]);
            if (beta <= alpha) {
                break;
            }
        }
        
        return alpha;
    } else {
        for (NSValue *move in possibleMoves) {
            ASHGameModel *model = [gameModel copy];
            ASHGameBoardPoint initialPlay = startingPlay;
            if (ASHGameBoardPointEqualToPoint(initialPlay, ASHGameBoardPointNull)) {
                initialPlay = move.gameBoardPointValue;
            }
            
            [model makeMove:move.gameBoardPointValue forPlayer:player];
            beta = MIN(beta, [self alphaBeta:model depth:depth-1 alpha:alpha beta:beta maximisingPlayer:ASHGameBoardPositionStatePlayerA initialPlay:initialPlay initialPlayer:initialPlayer]);
            if (beta <= alpha) {
                break;
            }
        }
        
        return beta;
    }
}

+(NSInteger)scoreForGameModel:(ASHGameModel *)gameModel player:(ASHGameBoardPositionState)player {
    NSInteger score = 0;
    
    for (NSUInteger x = 0; x < gameModel.gameBoard.width; x++) {
        for (NSUInteger y = 0; y < gameModel.gameBoard.height; y++) {
            ASHGameBoardPoint point = ASHGameBoardPointMake(x, y);
            ASHGameBoardPositionState state = [gameModel.gameBoard stateForPoint:point];
            
            if (state == player) {
                score++;
            } else if (state != ASHGameBoardPositionStateUndecided) {
                score--;
            }
        }
    }
    
    return score;
}

@end
