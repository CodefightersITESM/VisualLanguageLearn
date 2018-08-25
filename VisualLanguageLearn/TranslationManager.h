//
//  TranslationManager.h
//  VisualLanguageLearn
//
//  Created by César Barraza on 8/25/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "AFHTTPSessionManager.h"

static NSString* const ENGLISH = @"en";
static NSString* const SPANISH = @"es";
static NSString* const FRENCH = @"fr";

@interface TranslationManager : AFHTTPSessionManager
+ (instancetype)shared;

- (void)getTranslation:(NSString*)text source:(NSString*)source target:(NSString*)target completion:(void(^)(NSString* translatedText))completion;
@end
