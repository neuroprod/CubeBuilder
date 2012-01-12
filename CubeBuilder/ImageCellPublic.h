//
//  ImageCellPublic.h
//  CubeConstruct
//
//  Created by Kris Temmerman on 12/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCellPublic : UITableViewCell
{
NSURLConnection* connection;
    NSMutableData* data;

}

@property (nonatomic, retain)  UIImageView *image;
@property (nonatomic, retain)  UIButton * myButton2;
@property (nonatomic, retain)  UIActivityIndicatorView * actInd;
@property (nonatomic, retain)  NSString * dataurl;



-(void) setData:(NSString *) urlImage naam:(NSString *) naam data:(NSString *) urlData;
- (void)loadImageFromURL:(NSURL*)url;
@end
