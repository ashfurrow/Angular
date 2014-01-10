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

float randomFloat() {
    return (float)rand()/(float)RAND_MAX;
}

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

-(UIBezierPath *)pathForLayer:(CALayer *)layer parentRect:(CGRect)rect
{
    UIBezierPath *particlePath = [UIBezierPath bezierPath];
    [particlePath moveToPoint:layer.position];
    
    float r = ((float)rand()/(float)RAND_MAX) + 0.3f;
    float r2 = ((float)rand()/(float)RAND_MAX)+ 0.4f;
    float r3 = r*r2;
    
    int upOrDown = (r <= 0.5) ? 1 : -1;
    
    CGPoint curvePoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    float maxLeftRightShift = 1.f * randomFloat();
    
    CGFloat layerYPosAndHeight = (self.superview.frame.size.height-((layer.position.y+layer.frame.size.height)))*randomFloat();
    CGFloat layerXPosAndHeight = (self.superview.frame.size.width-((layer.position.x+layer.frame.size.width)))*r3;
    
    float endY = self.superview.frame.size.height-self.frame.origin.y;
    
    if (layer.position.x <= rect.size.width*0.5)
    {
        //going left
        endPoint = CGPointMake(-layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown)*maxLeftRightShift,-layerYPosAndHeight);
    }
    else
    {
        endPoint = CGPointMake(layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown+rect.size.width)*maxLeftRightShift, -layerYPosAndHeight);
    }
    
    [particlePath addQuadCurveToPoint:endPoint
                         controlPoint:curvePoint];
    
    return particlePath;
    
}

#pragma mark - Public Methods

-(void)newGame {
    self.piecesDictionary = [NSMutableDictionary dictionary];
    self.gameBoard = nil;
    
    NSArray *subviews = self.subviews;
    
    // Taken from https://github.com/vibrazy/letterpressexplosion
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CALayer *layer = view.layer;
        
        //Path
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = [[self pathForLayer:layer parentRect:self.bounds] CGPath];
        moveAnim.removedOnCompletion = YES;
        moveAnim.fillMode=kCAFillModeForwards;
        NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],nil];
        [moveAnim setTimingFunctions:timingFunctions];
        
        float r = randomFloat();
        
        NSTimeInterval speed = 2.35*r;
        
        CAKeyframeAnimation *transformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        CATransform3D startingScale = layer.transform;
        CATransform3D endingScale = CATransform3DConcat(CATransform3DMakeScale(randomFloat(), randomFloat(), randomFloat()), CATransform3DMakeRotation(M_PI*(1+randomFloat()), randomFloat(), randomFloat(), randomFloat()));
        
        NSArray *boundsValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:startingScale],
                                 
                                 [NSValue valueWithCATransform3D:endingScale], nil];
        [transformAnim setValues:boundsValues];
        
        NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:speed*.25], nil];
        [transformAnim setKeyTimes:times];
        
        
        timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                           nil];
        [transformAnim setTimingFunctions:timingFunctions];
        transformAnim.fillMode = kCAFillModeForwards;
        transformAnim.removedOnCompletion = NO;
        
        //alpha
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0f];
        opacityAnim.toValue = [NSNumber numberWithFloat:0.f];
        opacityAnim.removedOnCompletion = NO;
        opacityAnim.fillMode =kCAFillModeForwards;
        
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim,transformAnim,opacityAnim, nil];
        animGroup.duration = speed;
        animGroup.fillMode =kCAFillModeForwards;
        animGroup.delegate = self;
        [animGroup setValue:layer forKey:@"animationLayer"];
        [layer addAnimation:animGroup forKey:nil];
        
        //take it off screen
        [layer setPosition:CGPointMake(0, -600)];
    }];
    
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view removeFromSuperview];
        }];
    });
}

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
