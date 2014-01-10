//
//  ASHGameBoardViewController.h
//  Angular
//
//  Created by Ash Furrow on 1/5/2014.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

@interface ASHGameBoardViewController : UIViewController

@property (nonatomic, strong) NSString *turnString;
@property (nonatomic, strong) NSString *scoreString;

-(void)newGame;

@end
