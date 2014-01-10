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
#import "ASHComputerPlayerModel.h"

ASHGameBoardPositionState stateForPlayer(ASHGameBoardViewModelPlayer player) {
    return player == ASHGameBoardViewModelPlayerA ? ASHGameBoardPositionStatePlayerA : ASHGameBoardPositionStatePlayerB;
}

#define kComputerPlayer ASHGameBoardPositionStatePlayerB

@interface ASHGameBoardViewModel ()

// Private Properties
@property (nonatomic, strong) ASHGameModel *gameModel;

// Private Access
@property (nonatomic, assign) NSUInteger gameBoardWidth;
@property (nonatomic, assign) NSUInteger gameBoardHeight;
@property (nonatomic, assign) ASHGameBoardViewModelPlayer player;
@property (nonatomic, strong) RACSignal *gameBoardUpdatedSignal;
@property (nonatomic, strong) RACSubject *gameOverSignal;
@property (nonatomic, strong) RACSignal *computerIsThinkingSignal;

@property (nonatomic, strong) NSString *scoreString;
@property (nonatomic, strong) NSString *turnString;

@property (nonatomic, assign) BOOL computerIsThinking;

@end

@implementation ASHGameBoardViewModel

-(instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    
    self.gameModel = [[ASHGameModel alloc] initWithInitialBoard];
    
    self.gameBoardWidth = self.gameModel.gameBoard.width;
    self.gameBoardHeight = self.gameModel.gameBoard.height;
    
    self.gameBoardUpdatedSignal = [RACObserve(self, gameModel.gameBoard) deliverOn:[RACScheduler mainThreadScheduler]];  
    self.computerIsThinkingSignal = [RACObserve(self, computerIsThinking) deliverOn:[RACScheduler mainThreadScheduler]];
    self.gameOverSignal = [RACSubject subject];
    
    @weakify(self);
    [self.gameBoardUpdatedSignal subscribeNext:^(id _) {
        @strongify(self);
        
        if ([self.gameModel playerHasValidMove:stateForPlayer(self.player)] == NO) {
            [self switchPlayer];
            
            if ([self.gameModel playerHasValidMove:stateForPlayer(self.player)] == NO) {
                [self gameOver];
            }
        }
        
        if (self.player == ASHGameBoardViewModelPlayerB) {
            [[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh] schedule:^{
                self.computerIsThinking = YES;
                [self makeAIMove];
                self.computerIsThinking = NO;
                [self checkForWin];
            }];
        }
        
        [self checkForWin];
    }];
    
    RAC(self, turnString) = [self.gameBoardUpdatedSignal map:^id(id value) {
        @strongify(self);
        //lol
        return self.player == ASHGameModelBoardStatePlayerA ? @"It's your turn" : @"It's my turn";
    }];
    RAC(self, scoreString) = [self.gameBoardUpdatedSignal map:^id(ASHGameBoard *gameBoard) {
        NSInteger a = [gameBoard scoreForPlayer:ASHGameBoardPositionStatePlayerA];
        NSInteger b = [gameBoard scoreForPlayer:ASHGameBoardPositionStatePlayerB];
        return [NSString stringWithFormat:@"%d : %d", a, b];
    }];
    
    return self;
}

#pragma mark - Private Methods

-(void)switchPlayer {
    self.player = !self.player;
}

-(void)makeAIMove {
    ASHComputerPlayerModel *computerPlayer = [[ASHComputerPlayerModel alloc] initWithGameModel:self.gameModel];
    ASHGameBoardPoint play = [computerPlayer bestMoveForPlayer:kComputerPlayer];
    [self makePlay:play];
}

-(void)checkForWin {
    ASHGameModelBoardState state = self.gameModel.stateOfBoard;
    
    if (state != ASHGameModelBoardStateUndecided) {
        [self gameOver];
    }
}

-(void)gameOver {
    ASHGameModelBoardState state = self.gameModel.stateOfBoard;
    NSString *message = [NSString stringWithFormat:@"%@ win!", state == ASHGameModelBoardStatePlayerA ? @"You" : @"I"];
    [(RACSubject *)self.gameOverSignal sendNext:message];
    [(RACSubject *)self.gameOverSignal sendCompleted];
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
        self.gameModel = newModel;
    }
    
    return newModel != nil;
}

-(void)newGame {
    self.gameModel = [[ASHGameModel alloc] initWithInitialBoard];
}

@end
