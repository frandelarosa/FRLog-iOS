//
//  ViewController.m
//  FRLog iOS
//
//  Created by Francisco de la Rosa on 17/01/15.
//  Copyright (c) 2015 Fran. All rights reserved.
//

#import "ViewController.h"
#import "FRLog.h"


@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"FRLog"];
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIButton *BTN_sendPost = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 300, 100)];
    [BTN_sendPost setBackgroundColor:[UIColor redColor]];
    [BTN_sendPost setTitle:@"POST" forState:UIControlStateNormal];
    [BTN_sendPost addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:BTN_sendPost];
    
}

- (void)test{
    
    FRLogURL(@"http://www.myurl.com?req=get_users&init=10&limit=10");
    FRLogInfo(@"This is a Test");
    
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
