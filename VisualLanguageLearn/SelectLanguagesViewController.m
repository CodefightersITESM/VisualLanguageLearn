//
//  SelectLanguagesViewController.m
//  VisualLanguageLearn
//
//  Created by Diana Laura Benavides on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "SelectLanguagesViewController.h"
#import "SelectImageViewController.h"
#import "TranslationManager.h"
#import "Flashcard.h"
#import <CoreLocation/CoreLocation.h>

@import Firebase;


@interface SelectLanguagesViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *NativeLanguage;
@property (weak, nonatomic) IBOutlet UIPickerView *LearnLanguage;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) NSArray<NSDictionary*>* languages;
@end

@implementation SelectLanguagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NativeLanguage.dataSource = self;
    self.NativeLanguage.delegate = self;
    self.NativeLanguage.tag = 0;
    self.LearnLanguage.dataSource = self;
    self.LearnLanguage.delegate = self;
    self.LearnLanguage.tag = 1;
    
    NSLog(@"Country from select language: %@", self.country);

    self.nextButton.layer.cornerRadius = 10;
    self.nextButton.clipsToBounds = YES;
    
    // Do any additional setup after loading the view.
    [[TranslationManager shared] getSupportedLanguagesWithCompletion:^(NSArray<NSDictionary *> *languages) {
        self.languages = languages;
        [self.NativeLanguage reloadAllComponents];
        [self.LearnLanguage reloadAllComponents];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextClicked:(id)sender {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"selectImageSegue"])
    {
        SelectImageViewController* vc = [segue destinationViewController];
        vc.targetLanguage = self.languages[[self.LearnLanguage selectedRowInComponent:0]][@"language"];
        vc.sourceLanguage = self.languages[[self.NativeLanguage selectedRowInComponent:0]][@"language"];
        vc.currentLocation = self.currentLocation;
        vc.country = self.country;
    } 
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.languages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.languages[row][@"name"];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString* text = self.languages[row][@"name"];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, -18, pickerView.frame.size.width, 60)];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"AvenirNext" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    
    view = [[UIView alloc] init];
    [view addSubview:label];
    
    return view;
}
@end
