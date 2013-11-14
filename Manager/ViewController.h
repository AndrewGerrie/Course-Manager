//
//  ViewController.h
//  Manager
//
//  Created by Andrew on 30/03/2013.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Coruse.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *vert;
@property (strong, nonatomic) IBOutlet UIView *land;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIWebView *youTube; 
@property (weak, nonatomic) IBOutlet UIWebView *webViewVert;
@property (weak, nonatomic) IBOutlet UIView *videoVert;
@property (weak, nonatomic) IBOutlet UIWebView *webViewLand;
@property (strong, nonatomic) IBOutlet UIButton *viewedButton;
@property (strong, nonatomic) IBOutlet UILabel *partLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *description;
@property (strong, nonatomic) IBOutlet UITextView *notes; 
@property (strong, nonatomic) IBOutlet UITextView *ytDes;
@property (strong, nonatomic) IBOutlet UIButton *tweet;

- (IBAction)viewedButton:(id)sender;
- (IBAction)tweet:(id)sender;
@end


