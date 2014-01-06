//
//  ASHGameModel.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

@class ASHGameBoard;

@interface ASHGameModel : NSObject

-(instancetype)initWithGameBoard:(ASHGameBoard *)gameBoard;

@property (nonatomic, readonly) ASHGameBoard *gameBoard;

// Returns nil if move is invalid.
-(ASHGameModel *)move:(ASHGameBoardPoint)point isValidForPlayer:(ASHGameBoardPositionState)player;

-(ASHGameBoardPositionState)stateOfBoard;

@end
