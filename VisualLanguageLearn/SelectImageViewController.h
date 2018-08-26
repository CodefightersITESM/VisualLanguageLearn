//
//  SelectImageViewController.h
//  VisualLanguageLearn
//
//  Created by Diana Laura Benavides on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface SelectImageViewController : UIViewController
@property (strong, nonatomic) NSString* targetLanguage;
@property (strong, nonatomic) NSString* sourceLanguage;
@property (strong, nonatomic) CLLocation* currentLocation;
@property (strong, nonatomic) NSString *country;

@end
