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

@interface ASHGameBoardViewController ()

@property (nonatomic, strong) ASHGameBoardViewModel *viewModel;

@end

@implementation ASHGameBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self == nil) return nil;
    
    self.viewModel = [[ASHGameBoardViewModel alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
