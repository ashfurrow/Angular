//
//  ASHGameBoard.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

extern const NSUInteger ASHGameBoardDefaultWidth;
extern const NSUInteger ASHGameBoardDefaultHeight;

@interface ASHGameBoard : NSObject

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;

-(instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height;

-(ASHGameBoardPositionState)stateForPoint:(ASHGameBoardPoint)point;
-(void)setState:(ASHGameBoardPositionState)state forPoint:(ASHGameBoardPoint)point;

@end
