//
//  ImageCell.h
//  CubeConstruct
//
//  Created by Kris Temmerman on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell
@property (nonatomic, retain)  UIImageView *image;

-(void) setData:(NSInteger)dataID;
@end
