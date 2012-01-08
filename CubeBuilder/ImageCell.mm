//
//  ImageCell.m
//  CubeConstruct
//
//  Created by Kris Temmerman on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCell.h"
#import "SaveDataModel.h"

#include <iostream>
@implementation ImageCell
@synthesize image;
@synthesize cubeID;
@synthesize myButton;
@synthesize myButton2;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            
       image = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 310, 310)];
        
        [self addSubview:image];
        
        
        
       myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        myButton.frame = CGRectMake(20, 20, 200, 44); // position in the parent view and set the size of the button
        [myButton setTitle:@"Delete" forState:UIControlStateNormal];
        // add targets and actions
        [myButton addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
       
        [self addSubview:myButton];
        
        myButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        myButton2.frame = CGRectMake(20, 50, 200, 44); // position in the parent view and set the size of the button
        [myButton2 setTitle:@"Open" forState:UIControlStateNormal];
        // add targets and actions
        [myButton2 addTarget:self action:@selector(doOpen:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:myButton2];
        
        self.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
        
      
        
        
    }
    return self;
}
-(void) setData:(NSInteger)dataID
{
  
 cubeID = dataID;
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];  
      NSString  *filePath = [NSString stringWithFormat:@"%@/%i.png", documentsDirectory,dataID];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    

     image.image =  [UIImage imageWithData:pngData];
 
    
  
} 

- (void)doDelete:(id)sender
{

  [[SaveDataModel getInstance] deleteSaved:cubeID ];
  /// [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 
}
- (void)doOpen:(id)sender
{
    
   [[SaveDataModel getInstance] getCubeData:cubeID ];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    /*if(self.selected == selected)return;
    [super setSelected:selected animated:animated];

    
    if (selected)
    {
        image.alpha =0.5;
        
        [[SaveDataModel getInstance] getCubeData:cubeID ];
    }
    else
    {
      image.alpha =1.0;    }*/
}

@end
