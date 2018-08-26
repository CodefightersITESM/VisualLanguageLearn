//
//  LearnViewController.m
//  VisualLanguageLearn
//
//  Created by Hector Díaz Aceves on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "LearnViewController.h"
#import "Flashcard.h"

@import Firebase;

@interface LearnViewController ()

@property (weak, nonatomic) IBOutlet UILabel *originalLanguageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *objectImage;
@property (weak, nonatomic) IBOutlet UILabel *translationLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalWord;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSMutableArray *flashcards;

@property (nonatomic) int index;


@end

@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.index = 0;
    self.flashcards = [NSMutableArray new];
    [self fetchImagesFromCity];
    self.nextButton.layer.cornerRadius = 10;
    self.nextButton.clipsToBounds = YES;
}


- (IBAction)didTapNext:(id)sender {
    self.index += 1;
    [self prepareLearn];
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
            [self.flashcards addObject:flashcard];
            [self prepareLearn];
        }];
        
    }];
}

-(void) prepareLearn {
    if(self.index < self.flashcards.count){
        Flashcard *flashcard = [self.flashcards objectAtIndex: self.index];
        FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:flashcard.url];
        [storageRef dataWithMaxSize:(1*1024*1024) completion:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(error != nil){
                self.index += 1;
                [self prepareLearn];
            } else {
                UIImage *image = [UIImage imageWithData:data];
                self.objectImage.image = image;
            }
        }];
        
        self.originalLanguageLabel.text = flashcard.original;
        self.translationLanguageLabel.text = flashcard.translation;
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
