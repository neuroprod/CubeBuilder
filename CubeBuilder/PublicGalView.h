//
//  PublicGalView.h
//  CubeConstruct
//
//  Created by Kris Temmerman on 11/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorImageGalPublic.h"

@class ASIFormDataRequest ;
@interface PublicGalView : UIViewController
{
ASIFormDataRequest *request;

}
@property (nonatomic, retain)  HorImageGalPublic *gal;
@property (nonatomic,retain) ASIFormDataRequest *request;
@end



