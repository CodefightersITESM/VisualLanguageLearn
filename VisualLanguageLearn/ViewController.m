//
//  ViewController.m
//  VisualLanguageLearn
//
//  Created by Hector Díaz Aceves on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
@import Firebase;

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self takePicture];
}

-(void) takePicture {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    FIRVision *vision = [FIRVision vision];
    FIRVisionLabelDetector *labelDetector = [vision labelDetector];
    FIRVisionImage *image = [[FIRVisionImage alloc] initWithImage:editedImage];
    [labelDetector detectInImage:image completion:^(NSArray<FIRVisionLabel *> * _Nullable labels, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error getting the labels");
        } else {
            
            if(labels.count == 0){
                NSLog(@"No labels detected");
            } else {
                [self testTranslation:labels.firstObject.label];
//                for(FIRVisionLabel *label in labels){
//                    NSString *labelText = label.label;
//                    [self testTranslation:labelText];
//                    NSLog(@"Label Text: %@", labelText);
//                }
            }
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)testTranslation:(NSString*)text {
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    NSDictionary* params = @{@"q":text,
                             @"target":@"es",
                             @"format":@"text",
                             @"source":@"en",
                             @"key":@"AIzaSyCzwSy87KZ0AQJO6460slzTVLmt-5QLv8A"};
    NSString* baseURL = @"https://translation.googleapis.com/language/translate/v2";
    [manager POST:baseURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
