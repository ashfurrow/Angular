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
        // TODO: Check for adjacent blocks in all directions
    }
    
    return valid;
}

-(void)checkForWin {
    ASHGameBoardPositionState state = ASHGameBoardPositionStateUndecided;
    
    //TODO: Check for win condition
    
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
        // TODO: Update board
        [self switchPlayer];
        [(RACSubject *)self.gameBoardUpdatedSignal sendNext:nil];
    }
    
    return valid;
}

@end
