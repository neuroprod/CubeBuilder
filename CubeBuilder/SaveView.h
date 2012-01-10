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
    ASIFormDataRequest *request;
}

@property (nonatomic,retain) UIButton *saveAsNewBtn;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) ASIFormDataRequest *request;

- (IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)saveAsNew:(id)sender;

-(IBAction)saveOnline:(id)sender;
@end
