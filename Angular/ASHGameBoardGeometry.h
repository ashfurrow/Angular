//
//  ASHGameBoardGeometry.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

struct ASHGameBoardPoint {
    NSInteger x;
    NSInteger y;
};

typedef struct ASHGameBoardPoint ASHGameBoardPoint;

typedef NS_ENUM(NSUInteger, ASHGameBoardPositionState) {
    ASHGameBoardPositionStateUndecided = 0,
    ASHGameBoardPositionStatePlayerA,
    ASHGameBoardPositionStatePlayerB
};

static inline ASHGameBoardPoint ASHGameBoardPointMake(NSInteger x, NSInteger y)
{
    ASHGameBoardPoint p; p.x = x; p.y = y; return p;
}
