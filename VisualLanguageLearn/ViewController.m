//
//  ViewController.m
//  VisualLanguageLearn
//
//  Created by Hector Díaz Aceves on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "ViewController.h"
@import Firebase;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FIRVision *vision = [FIRVision vision];
    FIRVisionLabelDetector *labelDetector = [vision labelDetector];
    
    UIImage *uiImage = [UIImage imageNamed:@"Tree"];
    
    FIRVisionImage *image = [[FIRVisionImage alloc] initWithImage:uiImage];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
