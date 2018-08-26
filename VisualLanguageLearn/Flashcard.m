//
//  Flashcard.m
//  VisualLanguageLearn
//
//  Created by Hector Díaz Aceves on 25/08/18.
//  Copyright © 2018 Codefighters. All rights reserved.
//

#import "Flashcard.h"

@implementation Flashcard

-(instancetype) initWithSnapshot: (FIRDataSnapshot *) snapshot {
    
    self = [super init];
    if(self){
        
        self.latitude = [snapshot.value[@"latitude"] doubleValue];
        self.longitude = [snapshot.value[@"longitude"] doubleValue];
        self.original = snapshot.value[@"original"];
        self.translation = snapshot.value[@"translation"];
        self.url = snapshot.value[@"url"];
        
    }
    
    return self;
}

@end
