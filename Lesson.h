//
//  Lesson.h
//  Manager
//
//  Created by Andrew on 08/04/2013.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lesson : NSObject{
    int Id; //The lesson ID
    NSString *lessonName; //The lessonID
    NSString *lessonURL; //The URL for the video
    int part; //ie Part X of Y, this is x
    int totalParts; //This would be Y
    int viewed; //YES video is watched, NO video has not been viewed
    int courseID; //What courseID do these lessons belong too
    NSString *notes; //Notes user has made on this lesson
    NSString *des; //description from youtube

}

@property (assign)int Id;
@property (nonatomic,copy)NSString *lessonName;
@property (nonatomic,copy)NSString *lessonURL;
@property (assign)int part;
@property (assign)int totalParts;
@property (assign)int viewed;
@property (assign)int courseID;
@property (nonatomic,copy)NSString *notes;
@property (nonatomic,copy)NSString *des;

-(id)initID:(int)ID lessonName:(NSString *)lesson lessonURL:(NSString *)URL part:(int)currentPart totalParts:(int)total viewed:(int)view courseID:(int)cID notes:(NSString *)note des:(NSString *)d;

@end
