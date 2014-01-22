//
//  BiergartenRootControllerViewController.m
//  BiergartenApp
//
//  Created by Günter Platzer on 19.08.12.
//  Copyright (c) 2012 Günter Platzer. All rights reserved.
//

#import "BiergartenRootControllerViewController.h"
#import "BiergartenGAEFetcher.h"

@interface BiergartenRootControllerViewController ()

@end

@implementation BiergartenRootControllerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
      self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bayerflagge_480x800_ohne_alles.png"]];
    
    BiergartenGAEFetcher *myBiergartenFetcher = [[BiergartenGAEFetcher alloc] init];
    [myBiergartenFetcher loadBiergaerten];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
