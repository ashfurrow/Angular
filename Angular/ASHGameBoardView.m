//
//  ASHGameBoardView.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

// Views
#import "ASHGameBoardPieceView.h"
#import "ASHGameBoardView.h"

// Models
#import "ASHGameBoardViewModel.h"
#import "ASHGameBoard.h"

@interface ASHGameBoardView ()

@property (nonatomic, strong) ASHGameBoard *gameBoard;
@property (nonatomic, strong) NSMutableDictionary *piecesDictionary;

@property (assign) BOOL updating;

@end

@implementation ASHGameBoardView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.piecesDictionary = [NSMutableDictionary dictionary];
    
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(id x) {
        @strongify(self);
        
        [self.viewModel.gameBoardUpdatedSignal subscribeNext:^(ASHGameBoard *gameBoard) {
            @strongify(self);
            
            if (self.updating) {
                double delayInSeconds = 1.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self updateGameBoard:gameBoard];
                });
            } else {
                [self updateGameBoard:gameBoard];
            }
        }];
    }];
}

#pragma mark - Private Methods

-(NSArray *)addedPiecesToBoard:(ASHGameBoard *)newGameBoard {
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (NSInteger x = 0; x < newGameBoard.width; x++) {
        for (NSInteger y = 0; y < newGameBoard.height; y++) {
            ASHGameBoardPoint point = ASHGameBoardPointMake(x, y);
            ASHGameBoardPositionState oldState = [self.gameBoard stateForPoint:point];
            ASHGameBoardPositionState newState = [newGameBoard stateForPoint:point];
            
            if (oldState == ASHGameBoardPositionStateUndecided && newState != ASHGameBoardPositionStateUndecided) {
                [mutableArray addObject:[NSValue valueWithGameBoardPoint:point]];
            }
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

-(NSArray *)flippedPiecesToBoard:(ASHGameBoard *)newGameBoard {
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (NSInteger x = 0; x < newGameBoard.width; x++) {
        for (NSInteger y = 0; y < newGameBoard.height; y++) {
            ASHGameBoardPoint point = ASHGameBoardPointMake(x, y);
            ASHGameBoardPositionState oldState = [self.gameBoard stateForPoint:point];
            ASHGameBoardPositionState newState = [newGameBoard stateForPoint:point];
            
            if (oldState != ASHGameBoardPositionStateUndecided && newState != oldState) {
                [mutableArray addObject:[NSValue valueWithGameBoardPoint:point]];
            }
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

-(CGRect)frameForPoint:(ASHGameBoardPoint)point {
    NSUInteger cols = [self.dataSource numberOfColumnsForGameBoardView:self];
    NSUInteger rows = [self.dataSource numberOfRowsForGameBoardView:self];
    
    const CGFloat width = CGRectGetWidth(self.bounds) / cols;
    const CGFloat height = CGRectGetHeight(self.bounds) / rows;
    
    CGRect square = CGRectMake(width*point.x, height*point.y, width, height);
    return CGRectInset(square, 4, 4);
}

-(void)updateGameBoard:(ASHGameBoard *)newGameBoard {
    self.updating = YES;
    
    NSArray *addedPieces = [self addedPiecesToBoard:newGameBoard];
    NSArray *flippedPieces = [self flippedPiecesToBoard:newGameBoard];
    const CGFloat delayPerPiece = 0.3;
    
    [addedPieces enumerateObjectsUsingBlock:^(NSValue *pieceValue, NSUInteger idx, BOOL *stop) {
        ASHGameBoardPoint piece = pieceValue.gameBoardPointValue;
        
        ASHGameBoardPieceView *pieceView = [[ASHGameBoardPieceView alloc] init];
        pieceView.player = [newGameBoard stateForPoint:piece];
        pieceView.frame = [self frameForPoint:piece];
        [self addSubview:pieceView];
        
        [self.piecesDictionary setObject:pieceView forKey:pieceValue];
        
        [pieceView animateBeingAddedWithDelay:idx * delayPerPiece];
    }];
    
    CGFloat delay = addedPieces.count*delayPerPiece;
    double delayInSeconds = delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [flippedPieces enumerateObjectsUsingBlock:^(NSValue *pieceValue, NSUInteger idx, BOOL *stop) {
            ASHGameBoardPoint piece = pieceValue.gameBoardPointValue;
            
            ASHGameBoardPieceView *pieceView = [self.piecesDictionary objectForKey:pieceValue];
            
            [pieceView setPlayer:[newGameBoard stateForPoint:piece] animationDelay:delay];
        }];
    });
    
    delayInSeconds = delay + flippedPieces.count*delayPerPiece;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.updating = NO;
    });
    
    self.gameBoard = newGameBoard;
}

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
    
    for (NSUInteger x = 0; x < cols; x++) {
        for (NSUInteger y = 0; y < rows; y++) {
            
            UIColor *color;
            if ((x+y)%2 == 0) {
                color = evenGrey;
            } else {
                color = oddGreg;
            }
            
            [color set];
            
            UIRectFill(CGRectMake(width*x, height*y, width, height));
        }
    }
}

@end
