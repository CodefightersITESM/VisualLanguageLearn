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
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLLocation* currentLocation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initLocation];
    UIImage *image = [UIImage imageNamed:@"Tree"];
    [self uploadImageToFirebase:image];
}

- (void)initLocation {
    self.locationManager = [CLLocationManager new];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
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
                NSString* country = placemark.country;
                NSLog(@"%@", country);
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
    // Dispose of any resources that can be recreated.
}


@end
