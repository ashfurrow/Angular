//
//  ASHGameBoardView.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ASHGameBoardViewDisplayType) {
    ASHGameBoardViewDisplayTypeEmpty = 0,
    ASHGameBoardViewDisplayTypeRed,
    ASHGameBoardViewDisplayTypeBlue
};

@class ASHGameBoardView;

@protocol ASHGameBoardViewDataSource <NSObject>

-(NSUInteger)numberOfColumnsForGameBoardView:(ASHGameBoardView *)gameBoardView;
-(NSUInteger)numberOfRowsForGameBoardView:(ASHGameBoardView *)gameBoardView;

@end

@class ASHGameBoardViewModel;

@interface ASHGameBoardView : UIView

@property (nonatomic, weak) ASHGameBoardViewModel *viewModel;
@property (nonatomic, weak) id<ASHGameBoardViewDataSource> dataSource;

-(void)newGame;

-(ASHGameBoardPoint)pointAtPoint:(CGPoint)point;

@end
