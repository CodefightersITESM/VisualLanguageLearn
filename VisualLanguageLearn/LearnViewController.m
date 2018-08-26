//
//  LearnViewController.m
//  VisualLanguageLearn
//
//  Created by Hector Díaz Aceves on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "LearnViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Flashcard.h"

@import Firebase;

@interface LearnViewController ()

@property (weak, nonatomic) IBOutlet UILabel *originalLanguageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *objectImage;
@property (weak, nonatomic) IBOutlet UILabel *translationLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalWord;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSMutableArray *localFlashcards;
@property (strong, nonatomic) NSMutableArray *userFlashcards;
@property (weak, nonatomic) IBOutlet UISwitch *localGlobalSwitch;

@property (nonatomic) int index;


@end

@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.index = 0;
    self.localFlashcards = [NSMutableArray new];
    self.userFlashcards= [NSMutableArray new];
    [self fetchImagesFromCity];
    [self fetchImagesFromUser];
    self.nextButton.layer.cornerRadius = 10;
    self.nextButton.clipsToBounds = YES;
}


- (IBAction)didTapNext:(id)sender {
    self.index += 1;
    if([self.localGlobalSwitch isSelected]){
        [self prepareLearnLocal];
    } else {
        [self prepareLearnUser];
    }
    //[self prepareLearn];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) fetchImagesFromCity {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *countryReference = [[ref child:@"Countries"] child:self.country];
    [countryReference observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        FIRDatabaseReference *photoRef = [[ref child:@"Images"] child:snapshot.key];
        [photoRef observeEventType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            Flashcard *flashcard = [[Flashcard alloc] initWithSnapshot:snapshot];
            [self.localFlashcards addObject:flashcard];
            [self prepareLearnLocal];
        }];
        
    }];
}

-(void) fetchImagesFromUser {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    NSString *userId = [[[FIRAuth auth] currentUser] uid];
    FIRDatabaseReference *countryReference = [[ref child:@"User-Images"] child:userId];
    [countryReference observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        FIRDatabaseReference *photoRef = [[ref child:@"Images"] child:snapshot.key];
        [photoRef observeEventType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            Flashcard *flashcard = [[Flashcard alloc] initWithSnapshot:snapshot];
            [self.userFlashcards addObject:flashcard];
            [self prepareLearnUser];
        }];
        
    }];
}

-(void) prepareLearnLocal {
    if(self.index < self.localFlashcards.count){
        Flashcard *flashcard = [self.localFlashcards objectAtIndex: self.index];
        FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:flashcard.url];
        [storageRef dataWithMaxSize:(1*1024*1024) completion:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(error != nil){
                self.index += 1;
                [self prepareLearnLocal];
            } else {
                CLLocation *location = [[CLLocation alloc] initWithLatitude:flashcard.latitude longitude:flashcard.longitude];
                CLGeocoder *geocoder = [CLGeocoder new];
                [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                    if(error != nil){
                        self.originalWord.text = self.country;
                    } else {
                        CLPlacemark *placemark = [placemarks objectAtIndex:0];
                        self.originalWord.text = [NSString stringWithFormat:@"%@ , %@", placemark.addressDictionary[@"City"], self.country];
                        NSLog(@"%@", [NSString stringWithFormat:@"%@ , %@", placemark.addressDictionary[@"City"], self.country]);
                    }
                    
                }];
                UIImage *image = [UIImage imageWithData:data];
                self.objectImage.image = image;
            }
        }];
        self.originalLanguageLabel.text = flashcard.original;
        self.translationLanguageLabel.text = flashcard.translation;
    }
}

-(void) prepareLearnUser {
    if(self.index < self.userFlashcards.count){
        Flashcard *flashcard = [self.userFlashcards objectAtIndex: self.index];
        FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:flashcard.url];
        [storageRef dataWithMaxSize:(1*1024*1024) completion:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(error != nil){
                self.index += 1;
                [self prepareLearnLocal];
            } else {
                UIImage *image = [UIImage imageWithData:data];
                self.objectImage.image = image;
            }
        }];
        self.originalLanguageLabel.text = flashcard.original;
        self.translationLanguageLabel.text = flashcard.translation;
    }
}

- (IBAction)switchChanged:(id)sender {
    self.index = 0;
    if([self.localGlobalSwitch isSelected]){
        NSLog(@"Local selected");
        [self prepareLearnLocal];
    } else {
        NSLog(@"User selected");
        [self prepareLearnUser];
    }
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
