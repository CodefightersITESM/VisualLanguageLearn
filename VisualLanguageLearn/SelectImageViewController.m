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
#import <CoreLocation/CoreLocation.h>
#import "LearnViewController.h"


@import Firebase;
@interface SelectImageViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *translationLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;
@property (strong, nonatomic) CLLocationManager* locationManager;


@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocation];

    // Do any additional setup after loading the view.
    //[self fetchImagesFromCity];
}

- (void)initLocation {
    self.locationManager = [CLLocationManager new];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if(self.currentLocation == nil)
    {
        CLLocation* location = [locations lastObject];
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
        
        // get country
        CLGeocoder* geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(error == nil)
            {
                CLPlacemark* placemark = [placemarks firstObject];
                self.country = placemark.country;
                NSLog(@"Country from select image%@", self.country);
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapAdd:(id)sender {
    UIImage *imageSelected = self.image.image;
    [self uploadImageToFirebase:imageSelected];
    [self performSegueWithIdentifier:@"learnSegue" sender:self];
}

- (IBAction)didTapPicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
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
        
            NSLog(@"Error placing data");
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            int size = metadata.size;
            // You can also access to download URL after upload.
            [photoImagesRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error downloading url");
                } else {
                    
                    NSURL *downloadURL = URL;
                    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
                    
                    FIRDatabaseReference *photoReference = [[ref child:@"Images"] child:photoId];
                    NSNumber *latitude = [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
                    NSNumber *longitude = [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
                    [[photoReference child:@"latitude"] setValue:latitude];
                    [[photoReference child:@"longitude"] setValue:longitude];
                    [[photoReference child:@"original"] setValue:self.originalLabel.text];
                    [[photoReference child:@"translation"] setValue:self.translationLabel.text];
                    [[photoReference child:@"url"] setValue: [downloadURL absoluteString]];

                    NSLog(@"Country for uploading: %@", self.country);
                    FIRDatabaseReference *countryReference = [[ref child:@"Countries"] child: self.country];
                    
                    [[countryReference child:photoId] setValue:[NSNumber numberWithInt:1]];
                    
                    
                }
            }];
        }
        
    }];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    LearnViewController *viewController = [segue destinationViewController];
    viewController.country = self.country;
    
}


@end
