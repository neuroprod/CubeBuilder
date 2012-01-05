//
//  ImageCell.m
//  CubeConstruct
//
//  Created by Kris Temmerman on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCell.h"
#include <iostream>
@implementation ImageCell
@synthesize image;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            
       image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 330, 330)];
        image.backgroundColor = [UIColor yellowColor]; 
        [self addSubview:image];
            
        self.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
        
    }
    return self;
}
-(void) setData:(NSInteger)dataID
{
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];  
      NSString  *filePath = [NSString stringWithFormat:@"%@/%i.png", documentsDirectory,dataID];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    
    std::cout<<"\n"<< pngData.length << "numdata"<<"\n";
    
     image.image =  [UIImage imageWithData:pngData];
  
    
  
} 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        image.alpha =0.5;
    }
    else
    {
      image.alpha =1.0;    }
}

@end
