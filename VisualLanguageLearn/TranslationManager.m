//
//  TranslationManager.m
//  VisualLanguageLearn
//
//  Created by César Barraza on 8/25/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "TranslationManager.h"
#import <AFNetworking.h>

static NSString* const API_KEY = @"AIzaSyCzwSy87KZ0AQJO6460slzTVLmt-5QLv8A";

@implementation TranslationManager
+ (instancetype)shared {
    static TranslationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)getTranslation:(NSString *)text source:(NSString *)source target:(NSString *)target completion:(void (^)(NSString *))completion {
    NSDictionary* params = @{@"q":text,
                             @"target":target,
                             @"format":@"text",
                             @"source":source,
                             @"key":API_KEY};
    NSString* baseURL = @"https://translation.googleapis.com/language/translate/v2";
    [self POST:baseURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* translation = [NSArray arrayWithArray:responseObject[@"data"][@"translations"]].firstObject[@"translatedText"];
        completion(translation);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        completion(nil);
    }];
}

- (void)getSupportedLanguagesWithCompletion:(void (^)(NSArray<NSDictionary *> *))completion {
    NSDictionary* params = @{@"target":@"en",
                             @"key":API_KEY};
    NSString* baseURL = @"https://translation.googleapis.com/language/translate/v2/languages";
    [self POST:baseURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray<NSDictionary*>* languages = [[NSMutableArray alloc] init];
        for(NSDictionary* language in responseObject[@"data"][@"languages"])
        {
            [languages addObject:language];
        }
        completion([languages copy]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}
@end
