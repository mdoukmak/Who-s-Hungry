//
//  InviteViewController.m
//  WhosHungry
//
//  Created by Muhammad Doukmak on 11/21/14.
//  Copyright (c) 2014 Muhammad Doukmak. All rights reserved.
//

#import "InviteViewController.h"
#import "AFNetworking.h"

@interface InviteViewController ()
@property NSArray *numbers;
@end

@implementation InviteViewController
-(void)setContactNumbers:(NSMutableArray *)numbers {
    _numbers = numbers;
    static NSString * const BaseURLString = @"http://hamadeh.me/api/getcontacts";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSArray *params = _numbers;
    NSLog(@"%@", [params objectAtIndex:0]);
    [manager POST:BaseURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
