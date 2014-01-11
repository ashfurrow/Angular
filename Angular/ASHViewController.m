//
//  ASHViewController.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHViewController.h"
#import "ASHGameBoardViewController.h"

//Views
#import "ASHPlayerIndicatorView.h"
#import "ASHGameBoardPieceView.h"

@interface ASHViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UILabel *playerAScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerBScoreLabel;
@property (nonatomic, weak) IBOutlet ASHPlayerIndicatorView *playerATurnView;
@property (nonatomic, weak) IBOutlet ASHPlayerIndicatorView *playerBTurnView;

@property (nonatomic, weak) ASHGameBoardViewController *boardController;

@end

@implementation ASHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Configure Subviews
    NSInteger difficulty = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficulty"];
    self.segmentedControl.selectedSegmentIndex = difficulty;
    [[self.segmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *segmentedControl) {
        [[NSUserDefaults standardUserDefaults] setInteger:[segmentedControl selectedSegmentIndex] forKey:@"difficulty"];
    }];
    
    self.playerATurnView.backgroundColor = ASHGameBoardPieceViewPlayerAColor;
    self.playerBTurnView.backgroundColor = ASHGameBoardPieceViewPlayerBColor;
    
    // RAC Bindings
    RAC(self.playerAScoreLabel, text) = RACObserve(self, boardController.playerAScoreString);
    RAC(self.playerBScoreLabel, text) = RACObserve(self, boardController.playerBScoreString);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"board"]) {
        self.boardController = segue.destinationViewController;
    }
}

- (IBAction)newGame:(id)sender {
    [self.boardController newGame];
}

@end
