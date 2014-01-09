//
//  NSValue+ASHGameBoardGeometry.m
//  Angular
//
//  Created by Ash Furrow on 1/9/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "NSValue+ASHGameBoardGeometry.h"

@implementation NSValue (ASHGameBoardGeometry)

+(instancetype)valueWithGameBoardPoint:(ASHGameBoardPoint)point {
    return [self value:&point withObjCType:@encode(ASHGameBoardPoint)];
}

-(ASHGameBoardPoint)gameBoardPointValue {
    ASHGameBoardPoint point;
    [self getValue:&point];
    return point;
}

@end
