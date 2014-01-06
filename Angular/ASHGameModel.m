//
//  ASHGameModel.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameModel.h"
#import "ASHGameBoard.h"

@interface ASHGameModel ()

@property (nonatomic, strong) ASHGameBoard *gameBoard;

@end

@implementation ASHGameModel

-(instancetype)initWithGameBoard:(ASHGameBoard *)gameBoard {
    self = [super init];
    if (self == nil) return nil;
    
    self.gameBoard = gameBoard;
    
    return self;
}

#pragma mark - Public Methods

-(ASHGameModel *)move:(ASHGameBoardPoint)point isValidForPlayer:(ASHGameBoardPositionState)player {
    return nil;
}

@end
