//
//  ASHViewController.m
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHViewController.h"
#import "ASHGameBoardViewController.h"

@interface ASHViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, weak) ASHGameBoardViewController *boardController;

@end

@implementation ASHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSInteger difficulty = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficulty"];
    self.segmentedControl.selectedSegmentIndex = difficulty;
    [[self.segmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *segmentedControl) {
        [[NSUserDefaults standardUserDefaults] setInteger:[segmentedControl selectedSegmentIndex] forKey:@"difficulty"];
    }];
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
