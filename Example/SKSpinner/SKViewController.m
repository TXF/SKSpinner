//
//  SKViewController.m
//  SKSpinner
//
//  Created by David on 05/15/2015.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "SKViewController.h"
#import "SKSpinner.h"

@interface SKViewController ()

@end

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)start:(UIButton *)sender
{
    if(!sender.tag) {
        [SKSpinner showTo:self.view animated:YES];
        [sender setTitle:@"Hide HUD" forState:UIControlStateNormal];
    }
    
    else
    {
        [SKSpinner hideAnimated:NO];
        [sender setTitle:@"Show HUD" forState:UIControlStateNormal];
    }
    sender.tag = !sender.tag;
}


@end
