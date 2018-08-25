//
//  ViewController.m
//  VisualLanguageLearn
//
//  Created by Hector Díaz Aceves on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "TranslationManager.h"

@import Firebase;

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"Tree"];
    [self uploadImageToFirebase:image];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self takePicture];
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
            }
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)testTranslation:(NSString*)text {
    [[TranslationManager shared] getTranslation:@"apple" source:ENGLISH target:SPANISH completion:^(NSString *translatedText) {
        NSLog(@"%@", translatedText);
    }];
    
}


-(void) uploadImageToFirebase: (UIImage *)image {
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    NSString *photoId = [[NSUUID new] UUIDString];
    NSString *photoFile = [NSString stringWithFormat:@"%@.png", photoId];
    FIRStorageReference *photoRef = [storageRef child:photoFile];
    NSString *photoImagesReferenceString = [NSString stringWithFormat:@"images/%@", photoFile];
    FIRStorageReference *photoImagesRef = [storageRef child:photoImagesReferenceString];

    [photoRef.name isEqualToString:photoImagesRef.name];
    [photoRef.fullPath isEqualToString:photoImagesRef.fullPath];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    FIRStorageUploadTask *uploadTask = [photoImagesRef putData:imageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            int size = metadata.size;
            // You can also access to download URL after upload.
            [photoImagesRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    NSURL *downloadURL = URL;
                }
            }];
        }

    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
