//
//  SelectImageViewController.m
//  VisualLanguageLearn
//
//  Created by Diana Laura Benavides on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "SelectImageViewController.h"
@import Firebase;
#import "FIRAuth.h"

@interface SelectImageViewController ()

@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) userRegister : (NSString *)sMail Password: (NSString * )sPassword {
    
    
    [[FIRAuth auth] createUserWithEmail:sMail password:sPassword completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
    }];
    
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
