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

-(instancetype)initWithGameModel:(ASHGameModel *)gameModel {
    self = [super init];
    if (self == nil) return nil;
    
    self.gameModel = gameModel;
    
    return self;
}

-(ASHGameBoardPoint)bestMoveForPlayer:(ASHGameBoardPositionState)player {
    NSAssert(player != ASHGameBoardPositionStateUndecided, @"Player must exist.");
    BOOL played = NO;
    ASHGameBoardPoint play;
    
    for (NSUInteger x = 0; x < self.gameModel.gameBoard.width && played == NO; x++) {
        for (NSUInteger y = 0; y < self.gameModel.gameBoard.height && played == NO; y++) {
            ASHGameBoardPoint point = ASHGameBoardPointMake(x, y);
            
            ASHGameModel *model = [self.gameModel copy];
            BOOL success = [model makeMove:point forPlayer:player] != nil;
            
            if (success) {
                play = ASHGameBoardPointMake(x, y);
                played = YES;
            }
        }
    }
    
    return play;
}

@end
