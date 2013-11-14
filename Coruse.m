//
//  Coruse.m
//  Manager
//
//  Created by Andrew on 05/04/2013.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "Coruse.h"

@implementation Course

//create course object
-(id)initID:(int)ID course:(NSString *)course{
    if(self = [super init]){
        self.Id = ID;
        self.courseName = course;
    }
    return self;
}

//Memory management to release when no longer needed
-(void) dealloc{
    self.courseName = nil;
    
}

@end
