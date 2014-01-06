//
//  ASHGameModel.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

@class ASHGameBoard;

@interface ASHGameModel : NSObject <NSCopying>

-(id)initWithInitialBoard;

@property (nonatomic, readonly) ASHGameBoard *gameBoard;

// Returns a new game model representing the new board position, or nil if unnacceptable move.
-(ASHGameModel *)makeMove:(ASHGameBoardPoint)pointer forPlayer:(ASHGameBoardPositionState)player;
-(ASHGameBoardPositionState)stateOfBoard;

@end
