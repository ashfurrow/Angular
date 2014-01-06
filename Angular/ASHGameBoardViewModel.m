//
//  ASHGameBoardViewModel.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameBoardViewModel.h"

#import "ASHGameBoard.h"
#import "ASHGameModel.h"

static ASHGameBoardPositionState stateForPlayer(ASHGameBoardViewModelPlayer player) {
    return player == ASHGameBoardViewModelPlayerA ? ASHGameBoardPositionStatePlayerA : ASHGameBoardPositionStatePlayerB;
}


@interface ASHGameBoardViewModel ()

// Private Properties
@property (nonatomic, strong) ASHGameModel *gameModel;

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
    
    self.gameModel = [[ASHGameModel alloc] initWithInitialBoard];
    
    self.gameBoardWidth = self.gameModel.gameBoard.width;
    self.gameBoardHeight = self.gameModel.gameBoard.height;
    
    @weakify(self);
    self.gameBoardUpdatedSignal = [RACSubject subject];
    [self.gameBoardUpdatedSignal subscribeNext:^(id x) {
        @strongify(self);
        
        if (self.player == ASHGameBoardViewModelPlayerB) {
            [self makeAIMove];
        }
        
        [self checkForWin];
    }];
    
    return self;
}

#pragma mark - Private Methods

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
            
            ASHGameModel *model = [self.gameModel copy];
            BOOL success = [model makeMove:point forPlayer:stateForPlayer(self.player)] != nil;
            
            if (success) {
                [self makePlay:point];
                played = YES;
            }
        }
    }
}

-(void)checkForWin {
    ASHGameBoardPositionState state = self.gameModel.stateOfBoard;
    
    if (state != ASHGameBoardPositionStateUndecided) {
        [(RACSubject *)self.gameOverSignal sendNext:@(state)];
        [(RACSubject *)self.gameOverSignal sendCompleted];
    }
}

#pragma mark - Public Methods

-(ASHGameBoardPositionState)stateForPoint:(ASHGameBoardPoint)point {
    return [self.gameModel.gameBoard stateForPoint:point];
} 

-(BOOL)makePlay:(ASHGameBoardPoint)point {
    ASHGameModel *model = [self.gameModel copy];
    ASHGameModel *newModel = [model makeMove:point forPlayer:stateForPlayer(self.player)];
    if (newModel != nil) {
        [self switchPlayer];
        [(RACSubject *)self.gameBoardUpdatedSignal sendNext:newModel.gameBoard];
        self.gameModel = newModel;
    }
    
    return newModel != nil;
}

@end
