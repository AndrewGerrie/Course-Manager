//
//  Coruse.h
//  Manager
//
//  Created by Andrew on 05/04/2013.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject{
    int Id; //Course ID
    NSString *courseName; //Course name
    
}

@property (nonatomic,copy)NSString *courseName;
@property (assign)int Id;

-(id)initID:(int)ID course:(NSString *)course;


@end
