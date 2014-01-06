//
//  ASHGameBoardViewModel.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "RVMViewModel.h"

@interface ASHGameBoardViewModel : RVMViewModel

@property (nonatomic, readonly) NSUInteger gameBoardWidth;
@property (nonatomic, readonly) NSUInteger gameBoardHeight;

-(ASHGameBoardPositionState)stateForPoint:(ASHGameBoardPoint)point;

@end
