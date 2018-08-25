//
//  ViewController.m
//  VisualLanguageLearn
//
//  Created by Hector Díaz Aceves on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "ViewController.h"
@import Firebase;

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
                for(FIRVisionLabel *label in labels){
                    NSString *labelText = label.label;
                    NSLog(@"Label Text: %@", labelText);
                }
            }
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
