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

@property (nonatomic, weak) IBOutlet UIStepper *stepper;
@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, weak) ASHGameBoardViewController *boardController;

@end

@implementation ASHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.stepper.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficulty"];
    [[self.stepper rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIStepper *stepper) {
        [[NSUserDefaults standardUserDefaults] setInteger:stepper.value forKey:@"difficulty"];
    }];
    RAC(self.label, text) = [RACObserve(self.stepper, value) map:^id(id value) {
        return [NSString stringWithFormat:@"Recursions: %@", value];
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
