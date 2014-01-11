//
//  ASHGameBoardViewController.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "ASHGameBoardViewModel.h"

@interface ASHGameBoardViewController : UIViewController

@property (nonatomic, strong) NSString *playerAScoreString;
@property (nonatomic, strong) NSString *playerBScoreString;
@property (nonatomic, assign) ASHGameBoardViewModelPlayer player;

-(void)newGame;

@end
