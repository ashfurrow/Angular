//
//  ASHGameBoard+Private.h
//  Angular
//
//  Created by Ash Furrow on 1/6/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameBoard.h"

@interface ASHGameBoard (Private)

-(void)setState:(ASHGameBoardPositionState)state forPoint:(ASHGameBoardPoint)point;

@end