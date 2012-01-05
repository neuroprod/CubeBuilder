//
//  SaveView.h
//  CubeConstruct
//
//  Created by Kris Temmerman on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveView : UIViewController
{

    IBOutlet UIButton *saveAsNewBtn;
    IBOutlet UIImageView *imageView;
}

@property (nonatomic,retain) UIButton *saveAsNewBtn;
@property (nonatomic,retain) UIImageView *imageView;
- (IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)saveAsNew:(id)sender;
@end
