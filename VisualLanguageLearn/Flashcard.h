//
//  Flashcard.h
//  VisualLanguageLearn
//
//  Created by Hector Díaz Aceves on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FIRDataSnapshot.h"
@import Firebase;

@interface Flashcard : NSObject

@property (nonatomic, strong) NSString *original;
@property (nonatomic, strong) NSString *translation;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *url;
-(instancetype) initWithSnapshot: (FIRDataSnapshot *) snapshot;

@end
