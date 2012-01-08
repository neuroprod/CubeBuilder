//
//  ImageCell.h
//  CubeConstruct
//
//  Created by Kris Temmerman on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell

@property (readwrite,assign) int cubeID;
@property (nonatomic, retain)  UIImageView *image;
@property (nonatomic, retain)  UIButton * myButton2;
@property (nonatomic, retain)  UIButton * myButton ;

@property (nonatomic, retain)  UIButton *okBtn;
@property (nonatomic, retain)  UIButton *cancelBtn;


-(void) setData:(NSInteger)dataID;
@end
