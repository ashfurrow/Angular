//
//  ASHGameBoard.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameBoard.h"

const NSUInteger ASHGameBoardDefaultWidth = 8;
const NSUInteger ASHGameBoardDefaultHeight = 8;

@interface ASHGameBoard ()

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;

@property (nonatomic, assign) ASHGameBoardPositionState *board;

@end

@implementation ASHGameBoard

-(instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height {
    self = [super init];
    if (self == nil) return nil;
    
    self.width = width;
    self.height = height;
    
    self.board = malloc(sizeof(ASHGameBoardPositionState) * self.width * self.height);
    [self clearInitialBoard];
    
    return self;
}

-(void)dealloc {
    free(self.board);
}

#pragma mark - Private Methods

-(void)clearInitialBoard {
    for (NSUInteger x = 0; x < self.width; x++) {
        for (NSUInteger y = 0; y < self.height; y++) {
            [self setState:ASHGameBoardPositionStateUndecided forPoint:ASHGameBoardPointMake(x, y)];
        }
    }
}

-(ASHGameBoardPositionState*)positionStateAtPoint:(ASHGameBoardPoint)point {
    return &self.board[point.x * self.width + point.y];
}

#pragma mark - Public Methods

-(ASHGameBoardPositionState)stateForPoint:(ASHGameBoardPoint)point {
    ASHGameBoardPositionState *pointer = [self positionStateAtPoint:point];
    return *pointer;
}

-(void)setState:(ASHGameBoardPositionState)state forPoint:(ASHGameBoardPoint)point {
    ASHGameBoardPositionState *pointer = [self positionStateAtPoint:point];
    *pointer = state;
}

@end
