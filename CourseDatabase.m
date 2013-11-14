//
//  CourseDatabase.m
//  Manager
//
//  Created by Andrew on 07/04/2013.
//  Copyright (c) 2013 Andrew. All rights reserved.
//
// The class is built on top of the tutorial given by iGhalia http://youtu.be/VsXO98y5fVs


#import "CourseDatabase.h"
#import "Coruse.h"
#import "ViewController.h"
#import "Lesson.h"

@implementation CourseDatabase{
    NSMutableArray *courseArray; //Array to store the course list
}

static CourseDatabase *database; //single copy of sqlite database

//Load database
+(CourseDatabase *)database{
    if (database == nil){
        database = [[CourseDatabase alloc]init];
    }
    return database;
}

/*
 Method to get database path, or alert us if the database does not exist
 See video in header for full context if required
 */
-(id)init{
    self = [super init];
    
        NSString *sqlitePath = [[NSBundle mainBundle]pathForResource:@"course"ofType:@"sqlite"];
        
        if(sqlite3_open([sqlitePath UTF8String], &database) != SQLITE_OK){
            NSLog(@"fail"); //alert database hasn't been found
        }
    return self;
}


/*
 method lists lessons with the requested courseID
 This done by querying the sqlite database and creating lessons objects
 for each of the matching lessons to be inserted into the array
 */
-(NSArray *)listLesson:(int)courseID{
    NSMutableArray *outArray = [[NSMutableArray alloc]init]; 
    
    //create the query
    NSString *q = @"SELECT * FROM lessons WHERE courseID=";
    q = [q stringByAppendingFormat:[NSString stringWithFormat:@"%d",courseID]];
    
    sqlite3_stmt *stmt;//Store results
    
    if(sqlite3_prepare_v2(database, [q UTF8String], -1, &stmt, nil) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){ // while there are still results to proceed do..
            int ID = sqlite3_column_int(stmt, 0); //read results into from coloum 0 into variable 
            char *lessonChar = (char *) sqlite3_column_text(stmt, 1);
            NSString *lesson = [[NSString alloc]initWithUTF8String:lessonChar];
            char *lessonURLChar = (char *) sqlite3_column_text(stmt, 2);
            NSString *lessonURL = [[NSString alloc]initWithUTF8String:lessonURLChar];
            int part = sqlite3_column_int(stmt, 3);
            int totalParts = sqlite3_column_int(stmt, 4);
            int viewed = sqlite3_column_int(stmt, 5);
            int courseID = sqlite3_column_int(stmt, 6);
            char *lessonNotesChar = (char *) sqlite3_column_text(stmt, 7); 
            NSString *lessonNotes = [[NSString alloc]initWithUTF8String:lessonNotesChar];
            char *lessonDesChar = (char *) sqlite3_column_text(stmt, 8);
            NSString *lessonDes = [[NSString alloc]initWithUTF8String:lessonDesChar];
           
            //create the lesson object based on the this result
            Lesson *data = [[Lesson alloc] initID:ID lessonName:lesson lessonURL:lessonURL part:part totalParts:totalParts viewed:viewed courseID:courseID notes:lessonNotes des:lessonDes];
            
            [outArray addObject:data]; //add to the output array
        }
        
        sqlite3_finalize(stmt);//tidy up
        
    }
    return outArray; //return lessons array

}



/*
 Lists all the courses in the database
 returns them as an array
 */

-(NSArray *)listCourse{
    NSMutableArray *outArray = [[NSMutableArray alloc]init];
    
    NSString *q = @"SELECT * FROM coruse"; //query for all coruses
    sqlite3_stmt *stmt;
    
    if(sqlite3_prepare_v2(database, [q UTF8String], -1, &stmt, nil) == SQLITE_OK){ //if query is a success carry on

        while(sqlite3_step(stmt) == SQLITE_ROW){ //for each new row do...
            int ID = sqlite3_column_int(stmt, 0); //get coruse ID
            char *courseChar = (char *) sqlite3_column_text(stmt, 1); //get coruse name
            NSString *course = [[NSString alloc]initWithUTF8String:courseChar]; //covert course name to string
            
            Course *data = [[Course alloc] initID:ID course:course]; //make new course object
            
            [outArray addObject:data]; //add object to array
        }
        
        sqlite3_finalize(stmt); //tidy up
        
    }
    
    return outArray; //tidy up
}

/*
 Returns the number of lessons in a course that have been watched
 */
-(NSString *)viewedCount:(int)ID{
     
    NSString *q = [NSString stringWithFormat:@"SELECT COUNT(*) FROM lessons WHERE viewed = 1 AND courseID = %d",ID]; //query
    sqlite3_stmt *stmt;
    
    int viewed; //number of watched lessons
    int totalLessons; //total numeber of lessons in a course
    
    if(sqlite3_prepare_v2(database, [q UTF8String], -1, &stmt, nil) == SQLITE_OK){//if query is a success read a access
        while(sqlite3_step(stmt) == SQLITE_ROW){
            viewed = sqlite3_column_int(stmt, 0); //save numeber of viewed videos
        }
        sqlite3_finalize(stmt);
    }
    
    //Qurey for total number of lessons in the course
    q = [NSString stringWithFormat:@"SELECT totalParts FROM lessons WHERE courseID = %d LIMIT 1",ID]; 
    if(sqlite3_prepare_v2(database, [q UTF8String], -1, &stmt, nil) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            totalLessons = sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    return [NSString stringWithFormat:@"(%d/%d)",viewed,totalLessons]; //return as (X/Y) with X viewed lessons and Y as total videos in coruse
}

/*
  Method takes a lessonID and marks the video as viewed or unviewed
  depending on watched being (YES watched or NO not watched)
 */
-(void)viewed:(bool)watched lessonID:(int)ID{
    
    NSString *stmt;
  
    if(!watched){ //not watched marked as viewed
        stmt = [NSString stringWithFormat:@"UPDATE lessons SET viewed=%d WHERE lessonID = %d",0,ID];
    }else{ //watched mark as not viewed
         stmt = [NSString stringWithFormat:@"UPDATE lessons SET viewed=%d WHERE lessonID = %d",1,ID];
    }
    char *err;
    const char *stmtAsChar = [stmt UTF8String];
    if(sqlite3_exec(database, stmtAsChar, NULL, NULL, &err)==SQLITE_OK){ //update DB
        NSLog(@"viewed updated"); //alert this worked
    }
    
}

/*
 Updates the notes for a video at the given lessonID 
 */
-(void)updateNotes:(NSString *)notes lessonID:(int)ID{

    
    NSString *stmt; 
    
    stmt = [NSString stringWithFormat:@"UPDATE lessons SET notes='%@' WHERE lessonID = %d",notes,ID]; //Update to preform

    char *err;
    const char *stmtAsChar = [stmt UTF8String];
    if(sqlite3_exec(database, stmtAsChar, NULL, NULL, &err)==SQLITE_OK){ //update database
        NSLog(@"notes updated");//note this worked
    }
    
}

//close database when no longer required (memory management)
-(void)dealloc{
    sqlite3_close(database);
}

@end
