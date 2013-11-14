//
//  ViewController.m
//  Manager
//
//  Created by Andrew on 30/03/2013.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CourseDatabase.h"
#import "Coruse.h"
#import "Lesson.h"

@interface ViewController (){
    
    NSArray *tableArray; //Array holds what ever data is currently displayed in the menu
    NSArray *courseArray; //Array holds course objects
    NSMutableArray *lessonsArray; //Array holds currently selected lesson objects
    UISwipeGestureRecognizer *left; //Listens for swipes
    bool course; //To state is the user is YES on the course menu, or NO on the lesson MENU
    int lessonID; //currrently selected lesson
    int lessonRow; //currently selected row in tableview
    int courseID; //ID of currently selected course
    sqlite3 *db; //The database
    NSString *dbpath; //Where the database is being stored
    
}
@end

@implementation ViewController

/*
 On first load setup the basic required
 swipe recognizer for going back in the menu
 Load default guide video into player
 Setup listener for device rotations
 */
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    course = YES;
    [self setCourse]; //Load in coruses

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
     left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(reset:)];
    [left setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:left];
    
    NSURL *videoURL = [NSURL URLWithString:@"http://www.youtube.com/embed/Jsc4gHHF-O0"];

    
    [super viewDidLoad];
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    NSURLRequest *videoRequest = [NSURLRequest requestWithURL:videoURL];
    [[self youTube]loadRequest:videoRequest];
    self.youTube.scrollView.scrollEnabled = NO;
    
}

/*
 Gets all coruses from database, converts them to objects and then fill the 
 table array and course array with this infomation
*/
-(void)setCourse
{
   tableArray = [[CourseDatabase database]listCourse];
   courseArray = [[CourseDatabase database]listCourse];
   [[self tableView]reloadData];
}


/*
 Called when the device is rotated
 Redraw objects in correct location depending on view
 */
- (void)orientationChanged:(id)object{
    UIInterfaceOrientation interfaceOrintation = [[object object] orientation];
    
    if(interfaceOrintation == UIInterfaceOrientationPortrait || interfaceOrintation == UIInterfaceOrientationPortraitUpsideDown){
        self.view = self.vert;
        [self.youTube setFrame:CGRectMake(0, 0, 768, 400)];
        [self.tableView setFrame:CGRectMake(0,600 , 300, 400)];
        [self.ytDes setFrame:CGRectMake(350, 650, 350, 350)];
        [self.viewedButton setFrame:CGRectMake(350,600,100,40)];
        [self.partLabel setFrame:CGRectMake(480, 600, 100, 30)];
        [self.tweet setFrame:CGRectMake(680, 600, 60, 40)];
        [self.notes setFrame:CGRectMake(0, 400, 786, 200)];
        
        [self.view addSubview:self.notes];
        [self.view addSubview:self.partLabel];
        [self.view addSubview:self.viewedButton];
        [self.view addSubview:self.tweet];
        [self.view addSubview:self.partLabel];
        [self.view addSubview:self.ytDes];
    
        [self.view addSubview:self.youTube];
        [self.view addSubview:self.tableView];
         
        [left setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:left];
        
    }
    
    if(interfaceOrintation == UIInterfaceOrientationLandscapeLeft || interfaceOrintation == UIInterfaceOrientationLandscapeRight){
        
        self.view = self.land;
        [self.youTube setFrame:CGRectMake(320, 0, 705, 400)];
        [self.tableView setFrame:CGRectMake(0, 0, 300, 768)];
        [self.ytDes setFrame:CGRectMake(350, 450, 490, 320)];
        [self.viewedButton setFrame:CGRectMake(400,405,100,40)];
        [self.partLabel setFrame:CGRectMake(540, 410, 100, 30)];
        [self.tweet setFrame:CGRectMake(900, 410, 60, 40)];
        
        [self.view addSubview:self.youTube];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.partLabel];
        [self.view addSubview:self.viewedButton];
        [self.view addSubview:self.tweet];
        [self.view addSubview:self.ytDes];
        
        [left setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:left];
    }
    
}

/*
 Number of sections in table view, this is only one so can be hard set
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/*
 The length of the table view is the same as length of coruses or lessons in the table array
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableArray count];
}

/*
 Called when ever the tableview needs to be updated
 tabeleview is based on the youtube video http://www.youtube.com/watch?v=YEaxIVv-EPI
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
         
    static NSString *cellIdentifer = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if(cell == nil){
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    if(course){ //if a coruse add this data
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        Course *obj = tableArray[indexPath.row];
        NSString *viewed = [[CourseDatabase database]viewedCount:obj.Id];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",obj.courseName,viewed];
    }else{ //if not a course add this data
        cell.accessoryType = UITableViewCellAccessoryNone;
        Lesson *obj = tableArray[indexPath.row];
        cell.textLabel.text = obj.lessonName;
        if(obj.viewed == 1){ // if video is viewed mark add tick to it
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
     
    }

    return cell;
}


/*
 Called when a table view row is selcted
 actions depend varying on if a lesson or coruse is selected
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(course){
        tableArray = [[CourseDatabase database]listLesson:indexPath.row];
        courseID = indexPath.row;
        course = NO;

    }else{
        [[CourseDatabase database]updateNotes:self.notes.text lessonID:lessonID];
        tableArray = [[CourseDatabase database]listLesson:courseID];
        Lesson *obj = tableArray[indexPath.row];
        [lessonsArray addObject:obj];
        NSURL *videoURL = [NSURL URLWithString:obj.lessonURL];
        lessonID = obj.Id;
        lessonRow = indexPath.row;
        courseID = obj.courseID;
        self.notes.text = obj.notes;
        if(obj.viewed == 1){
            [self.viewedButton setTitle:@"Viewed" forState:UIControlStateNormal];
        }else{
              [self.viewedButton setTitle:@"Not Viewed" forState:UIControlStateNormal];
        }
        self.ytDes.text = obj.des;
        self.partLabel.text = [NSString stringWithFormat:@"%@%d%@%d", @"Part ", obj.part, @ " of ",obj.totalParts];
        
      NSURLRequest *videoRequest = [NSURLRequest requestWithURL:videoURL];
      [[self youTube]loadRequest:videoRequest]; //load video into player
    }
   
    [[self tableView]reloadData];
}

/*
 Marks the currently displayed video as viewed or not viewed in the database for that video
 */
-(IBAction)viewedButton:(id)sender{
    if(!course){ //Don't allow the button to work on coruses menu
        Lesson *obj = tableArray[lessonRow];
    
        if(obj.viewed == 1){ //if viewed mark as not viewed
            [self.viewedButton setTitle:@"Not Viewed" forState:UIControlStateNormal];
            [[CourseDatabase database]viewed:NO lessonID:lessonID];
        }else{ //if not viewed mark as viewed
            [self.viewedButton setTitle:@"Viewed" forState:UIControlStateNormal];
            [[CourseDatabase database]viewed:YES lessonID:lessonID];
        }
    
        tableArray = [[CourseDatabase database]listLesson:courseID]; //Update tableView so lesson gets tick showing it's viewed

        [[self tableView]reloadData];
    }
}

/*
 Takes the current video and lets the user tweet they are watching it
 */
- (IBAction)tweet:(id)sender{
      if(!course){ //Don't allow button to work on coruses menu
          Lesson *obj = tableArray[lessonRow];
          NSString *lessonName = [obj.lessonName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
          NSString *lessonURL = [obj.lessonURL stringByReplacingOccurrencesOfString:@"http://www.youtube.com/embed/" withString:@"http://www.youtube.com/watch?v="];
          NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@", @"http://twitter.com/share?url=", lessonURL, @"&text=I+am+watching+",lessonName,@"+with+course+master"];
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    }
}

/*
 Resets the the menu to display courses when a swipe is made
 */
-(void)reset:(UISwipeGestureRecognizer *)dir
{
    course = YES;
    tableArray = courseArray;
    [[self tableView]reloadData];
}

/*
 Makes the keyboard go away when not in use (see stackoverflow link)
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //http://stackoverflow.com/questions/804563/how-to-hide-the-keyboard-when-empty-area-is-touched-on-iphone
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
