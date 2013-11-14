//
//  CourseDatabase.h
//  Manager
//
//  Created by Andrew on 07/04/2013.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CourseDatabase : NSObject{
    sqlite3 *database;
}

+(CourseDatabase *)database;

-(NSArray *)listCourse;
-(NSArray *)listLesson:(int)courseID;
-(void)viewed:(bool)watched lessonID:(int)ID;
-(void)updateNotes:(NSString *)notes lessonID:(int)ID;
-(NSString *)viewedCount:(int)ID;

@end
