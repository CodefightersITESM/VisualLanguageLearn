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


@end

@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)didTapNext:(id)sender {
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
