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
    
    UIColor *evenGrey = [UIColor colorWithHexString:@"E6FBFF"];
    UIColor *oddGreg = [UIColor colorWithHexString:@"cfe2e6"];
    UIColor *blue = [UIColor colorWithHexString:@"63E4FF"];
    UIColor *red = [UIColor colorWithHexString:@"FF4733"];
    
    for (NSUInteger x = 0; x < cols; x++) {
        for (NSUInteger y = 0; y < rows; y++) {
            ASHGameBoardViewDisplayType type = [self.dataSource displayTypeForPoint:ASHGameBoardPointMake(x, y)];
            
            UIColor *color;
            switch (type) {
                case ASHGameBoardViewDisplayTypeEmpty:
                    if ((x+y)%2 == 0) {
                        color = evenGrey;
                    } else {
                        color = oddGreg;
                    }
                    break;
                case ASHGameBoardViewDisplayTypeBlue:
                    color = blue;
                    break;
                case ASHGameBoardViewDisplayTypeRed:
                    color = red;
            }
            
            [color set];
            
            UIRectFill(CGRectMake(width*x, height*y, width, height));
        }
    }
}

@end
