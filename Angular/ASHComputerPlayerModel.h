//
//  ASHComputerPlayerModel.h
//  Angular
//
//  Created by Ash Furrow on 1/8/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASHGameModel;

@interface ASHComputerPlayerModel : NSObject

-(instancetype)initWithGameModel:(ASHGameModel *)gameModel;

@property (nonatomic, readonly) ASHGameModel *gameModel;

-(ASHGameBoardPoint)bestMoveForPlayer:(ASHGameBoardPositionState)player;

@end
