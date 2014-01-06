//
//  ASHGameModel.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ASHGameModelBoardState) {
    ASHGameModelBoardStatePlayerA = 0,
    ASHGameModelBoardStatePlayerB,
    ASHGameModelBoardStateTie,
    ASHGameModelBoardStateUndecided
};

@class ASHGameBoard;

@interface ASHGameModel : NSObject <NSCopying>

-(id)initWithInitialBoard;

@property (nonatomic, readonly) ASHGameBoard *gameBoard;

// Returns a new game model representing the new board position, or nil if unnacceptable move.
-(ASHGameModel *)makeMove:(ASHGameBoardPoint)point forPlayer:(ASHGameBoardPositionState)player;
-(BOOL)playerHasValidMove:(ASHGameBoardPositionState)player;
-(ASHGameModelBoardState)stateOfBoard;

@end
