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

@interface SelectLanguagesViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *NativeLanguage;
@property (weak, nonatomic) IBOutlet UIPickerView *LearnLanguage;

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
    
    // Do any additional setup after loading the view.
    [[TranslationManager shared] getSupportedLanguagesWithCompletion:^(NSArray<NSDictionary *> *languages) {
        self.languages = languages;
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
        
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

@end