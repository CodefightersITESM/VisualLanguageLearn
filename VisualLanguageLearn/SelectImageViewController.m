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
#import "TranslationManager.h"

@import Firebase;
@interface SelectImageViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
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

- (IBAction)didTapPicture:(id)sender {
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
                NSString* text = labels.firstObject.label;
                [[TranslationManager shared] getTranslation:text source:self.sourceLanguage target:self.targetLanguage completion:^(NSString *translatedText) {
                    self.originalLabel.text = text;
                    self.translationLabel.text = translatedText;
                    self.image.image = editedImage;
                }];
            }
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
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
