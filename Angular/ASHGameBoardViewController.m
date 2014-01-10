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

@property (nonatomic, strong) ASHGameBoardView *view;
@property (nonatomic, strong) ASHGameBoardViewModel *viewModel;


@end

@implementation ASHGameBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.viewModel = [[ASHGameBoardViewModel alloc] init];
    self.view.viewModel = self.viewModel;
    
    self.view.dataSource = self;
    
    @weakify(self);
    [[self.viewModel gameBoardUpdatedSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.view setNeedsDisplay];
    }];
    [[self.viewModel gameOverSignal] subscribeNext:^(id x) {
        [[[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Game has ended. " delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }];
    
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    [recognizer.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer *recognizer) {
        @strongify(self);
        
        ASHGameBoardPoint point = [self.view pointAtPoint:[recognizer locationInView:self.view]];
        
        [self.viewModel makePlay:point];
    }];
    [self.view addGestureRecognizer:recognizer];
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
