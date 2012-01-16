//
//  SaveView.h
//  CubeConstruct
//
//  Created by Kris Temmerman on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ASIFormDataRequest;
@interface SaveView : UIViewController
{

    IBOutlet UIButton *saveAsNewBtn;
    IBOutlet UIImageView *imageView;
    IBOutlet UIProgressView * progressIndicator;
    IBOutlet UITextField *textField;
    IBOutlet UIButton  *saveBtn;
     IBOutlet UIButton  *saveOnlineBtn;
    ASIFormDataRequest *request;
}

@property (nonatomic,retain) UIButton *saveAsNewBtn;
@property (nonatomic,retain) UIButton *saveBtn;
@property (nonatomic,retain) UIButton *saveOnlineBtn;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) ASIFormDataRequest *request;
@property (nonatomic,retain) UIProgressView * progressIndicator;

@property (nonatomic,retain) UITextField * textField;

- (IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)resignFR :(id)sender;
-(IBAction)saveAsNew:(id)sender;

-(IBAction)saveOnline:(id)sender;

- (NSString*)MD5:(NSString *)s;
@end
