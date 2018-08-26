//
//  SelectImageViewController.m
//  VisualLanguageLearn
//
//  Created by Diana Laura Benavides on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "SelectImageViewController.h"
#import "FIRAuth.h"
#import "Flashcard.h"
#import "FIRDatabaseReference.h"
@import Firebase;
@interface SelectImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *translationLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;

@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self fetchImagesFromCity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) userRegister : (NSString *)sMail Password: (NSString * )sPassword {
    
    
    [[FIRAuth auth] createUserWithEmail:sMail password:sPassword completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
    }];
    
}

-(void) fetchImagesFromCity {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *countryReference = [[ref child:@"Countries"] child:@"United States"];
    [countryReference observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"Snapshot: %@", snapshot.key);
        
        FIRDatabaseReference *photoRef = [[ref child:@"Images"] child:snapshot.key];
        
        [photoRef observeEventType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"Photo Snapshot: %@", snapshot);
            
            Flashcard *flashcard = [[Flashcard alloc] initWithSnapshot:snapshot];
            
        }];
        
    }];
}

- (IBAction)didTapAdd:(id)sender {
    [self performSegueWithIdentifier:@"learnSegue" sender:self];
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
