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
        
        
        
       myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(310-64+7+5, +5, 64, 64); // position in the parent view and set the size of the button
        [myButton setTitle:@"Delete" forState:UIControlStateNormal];
        // add targets and actions
        UIImage * btnImage = [UIImage imageNamed:@"deleteBtn.png"];
        [myButton setImage:btnImage forState:UIControlStateNormal];

        myButton.alpha =0.6;
        
        [myButton addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
       
        myButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton2.frame = CGRectMake(0+7, +5,310, 310); // position in the parent view and set the size of the button
        [myButton2 setTitle:@"Open" forState:UIControlStateNormal];
        // add targets and actions
        
        UIImage * btnImage2 = [UIImage imageNamed:@"openBtn.png"];
        [myButton2 setImage:btnImage2 forState:UIControlStateNormal];
        
        
        [myButton2 addTarget:self action:@selector(doOpen:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:myButton2];
        [self addSubview:myButton];
        

        self.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
        
      
       self.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
        
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
    NSNumber *n = [NSNumber numberWithInt:cubeID];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleterow" object: n ]; 
    
 //[self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 
}
- (void)doOpen:(id)sender
{
    
   [[SaveDataModel getInstance] getCubeData:cubeID ];
    
}/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(self.selected == selected)return;
    [super setSelected:selected animated:animated];

    
    if (selected)
    {
        image.alpha =0.5;
        
        [[SaveDataModel getInstance] getCubeData:cubeID ];
    }
    else
    {
      image.alpha =1.0;    }
}*/

@end
