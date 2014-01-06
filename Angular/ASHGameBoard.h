//
//  ASHGameBoard.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

struct ASHGameBoardPoint {
    NSUInteger x;
    NSUInteger y;
};

typedef struct ASHGameBoardPoint ASHGameBoardPoint;


typedef NS_ENUM(NSUInteger, ASHGameBoardPositionState) {
    ASHGameBoardPositionStateUndecided = 0,
    ASHGameBoardPositionStatePlayerA,
    ASHGameBoardPositionStatePlayerB
};

@interface ASHGameBoard : NSObject

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;

-(ASHGameBoardPositionState)stateForPosition:(ASHGameBoardPoint)point;

@end
