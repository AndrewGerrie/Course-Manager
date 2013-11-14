//
//  Lesson.m
//  Manager
//
//  Created by Andrew on 08/04/2013.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "Lesson.h"

@implementation Lesson


//Constuct a lesson object

-(id)initID:(int)ID lessonName:(NSString *)lesson lessonURL:(NSString *)URL part:(int)currentPart totalParts:(int)total viewed:(int)view courseID:(int)cID notes:(NSString *)note des:(NSString *)d{
    
    if(self = [super init]){
        self.Id = ID;
        self.lessonName = lesson;
        self.lessonURL = URL;
        self.part = currentPart;
        self.totalParts = total;
        self.viewed = view;
        self.courseID = cID;
        self.notes = note;
        self.des = d;
    }
    return self; 
}

//Memory management when no longer required release
-(void) dealloc{
    self.lessonName = nil;
    self.lessonURL = nil;
}


@end
