//
//  ViewController.m
//  MyCaroussel
//
//  Created by Mohamed BOUMANSOUR on 6/7/17.
//  Copyright © 2017 Mohamed. All rights reserved.
//

#import "ViewController.h"

#import <MyCaroussel-Swift.h>



@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    CarouselView *carouselView = [[CarouselView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:carouselView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
