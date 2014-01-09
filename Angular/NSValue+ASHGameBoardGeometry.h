//
//  NSValue+ASHGameBoardGeometry.h
//  Angular
//
//  Created by Ash Furrow on 1/9/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (ASHGameBoardGeometry)

+(instancetype)valueWithGameBoardPoint:(ASHGameBoardPoint)point;
-(ASHGameBoardPoint)gameBoardPointValue;

@end
