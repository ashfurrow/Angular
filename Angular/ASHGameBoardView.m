//
//  ASHGameBoardView.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameBoardView.h"

@implementation ASHGameBoardView

#pragma mark - Public Methods

-(ASHGameBoardPoint)pointAtPoint:(CGPoint)point {
    NSUInteger cols = [self.dataSource numberOfColumnsForGameBoardView:self];
    NSUInteger rows = [self.dataSource numberOfRowsForGameBoardView:self];
    
    const NSUInteger colWidth = CGRectGetWidth(self.bounds) / cols;
    const NSUInteger rowHeight = CGRectGetHeight(self.bounds) / rows;
    
    NSUInteger x = ((NSUInteger)point.x) / colWidth;
    NSUInteger y = ((NSUInteger)point.y) / rowHeight;
    
    return ASHGameBoardPointMake(x, y);
}

#pragma mark - Overridden Methods

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    NSUInteger cols = [self.dataSource numberOfColumnsForGameBoardView:self];
    NSUInteger rows = [self.dataSource numberOfRowsForGameBoardView:self];
    
    const CGFloat width = CGRectGetWidth(self.bounds) / cols;
    const CGFloat height = CGRectGetHeight(self.bounds) / rows;
    
    for (NSUInteger x = 0; x < cols; x++) {
        for (NSUInteger y = 0; y < rows; y++) {
            ASHGameBoardViewDisplayType type = [self.dataSource displayTypeForPoint:ASHGameBoardPointMake(x, y)];
            
            UIColor *color;
            switch (type) {
                case ASHGameBoardViewDisplayTypeEmpty:
                    color = nil;
                    break;
                case ASHGameBoardViewDisplayTypeBlue:
                    color = [UIColor blueColor];
                    break;
                case ASHGameBoardViewDisplayTypeRed:
                    color = [UIColor redColor];
            }
            
            if (color) {
                [color set];
                
                UIRectFill(CGRectMake(width*x, height*y, width, height));
            }
        }
    }
}

@end
