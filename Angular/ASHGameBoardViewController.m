//
//  ASHGameBoardViewController.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameBoardViewController.h"

// View Model
#import "ASHGameBoardViewModel.h"

// Views
#import "ASHGameBoardView.h"

@interface ASHGameBoardViewController () <ASHGameBoardViewDataSource>

@property (nonatomic, strong) ASHGameBoardViewModel *viewModel;

@end

@implementation ASHGameBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.viewModel = [[ASHGameBoardViewModel alloc] init];
    
    if ([self.view isKindOfClass:[ASHGameBoardView class]]) {
        [(ASHGameBoardView *)self.view setDataSource:self];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view setNeedsDisplay];
}

#pragma mark - ASHGameBoardViewDataSource Methods

-(NSUInteger)numberOfColumnsForGameBoardView:(ASHGameBoardView *)gameBoardView {
    return self.viewModel.gameBoardWidth;
}

-(NSUInteger)numberOfRowsForGameBoardView:(ASHGameBoardView *)gameBoardView {
    return self.viewModel.gameBoardHeight;
}

-(ASHGameBoardViewDisplayType)displayTypeForPoint:(ASHGameBoardPoint)point {
    ASHGameBoardPositionState state = [self.viewModel stateForPoint:point];
    
    switch (state) {
        case ASHGameBoardPositionStatePlayerA:
            return ASHGameBoardViewDisplayTypeBlue;
        case ASHGameBoardPositionStatePlayerB:
            return ASHGameBoardViewDisplayTypeRed;
        case ASHGameBoardPositionStateUndecided:
            return ASHGameBoardViewDisplayTypeEmpty;
    }
}

@end
