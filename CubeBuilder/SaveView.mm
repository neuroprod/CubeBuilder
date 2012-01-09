//
//  SaveView.m
//  CubeConstruct
//
//  Created by Kris Temmerman on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveView.h"
#include "Model.h"
#include "SaveDataModel.h"
@implementation SaveView

@synthesize saveAsNewBtn;
@synthesize imageView;




- (IBAction)cancel:(id)sender{Model::getInstance()->cancelOverlay();}
-(IBAction)save:(id)sender
{
    int *cubeData =Model::getInstance()->cubeHandler->getCubeData();
    int size  = Model::getInstance()->cubeHandler->cubes.size()*4;
       NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:size];
    for ( int i = 0 ; i < size; i ++ )
        [array addObject:[NSNumber numberWithInt:cubeData[i]]];

        
        
    NSData *img = UIImagePNGRepresentation(self.imageView.image);
   
    NSData *cube= [NSKeyedArchiver archivedDataWithRootObject:array];
  
    if (Model::getInstance()->currentLoadID ==-1)
    {
        [[SaveDataModel getInstance] saveData:img cubeData:cube ];
    }else
    {
    
      [[SaveDataModel getInstance] saveDataCurrent:img cubeData:cube ];
    }
    Model::getInstance()->cancelOverlay();
    
    //[[SaveDataModel getInstance] getAllData];

}
-(IBAction)saveAsNew:(id)sender
{
    int *cubeData =Model::getInstance()->cubeHandler->getCubeData();
    int size  = Model::getInstance()->cubeHandler->cubes.size()*4;
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:size];
    for ( int i = 0 ; i < size; i ++ )
        [array addObject:[NSNumber numberWithInt:cubeData[i]]];
    
    
    
    NSData *img = UIImagePNGRepresentation(self.imageView.image);
   
    NSData *cube= [NSKeyedArchiver archivedDataWithRootObject:array];
    
    
    [[SaveDataModel getInstance] saveData:img cubeData:cube ];
    
    Model::getInstance()->cancelOverlay();


}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    Model * model =Model::getInstance();
   model->isDirty =true;
   
      GLubyte *pixeldata  = model->pixeldata;
    GLubyte *buffer2 = (GLubyte *) malloc(768*1024*4);
   
    int wS;
    int hS;
    int pW = model->pixelW;
    if ( model->pixelW ==1024)
    {
        wS = 0;
        hS =119;
    
    }else
    {
        wS = 119;
        hS =0;

    
    }
   
    int h =768;
    int w =768;
    int countX =0;
    int countY =0;
    int yr = 0;
    int xr =0;
    for(int y = wS; y <h+wS; ++y)
    {
        xr = ( w-1- countY) * h  * 4;
        yr = y * 4 * pW;
        for(int x = hS*4; x <(w+hS)* 4; ++x)
        {
            
            buffer2[xr + countX ] = pixeldata [yr + x];
                countX++;
        }
        countX =0;
        countY++;
    }
    delete [] pixeldata;
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, 768*1024*4, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w , h, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
   
   /* CGSize *newSize
    
    UIGraphicsBeginImageContext(newSize);
    [myImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
*/
    
    
    
    
    
    
    
    
    
    
    [imageView setImage:myImage];  
    
    if ( Model::getInstance()->currentLoadID ==-1)
    {
        [saveAsNewBtn setHidden:true];
    }else
    {
    
        [saveAsNewBtn setHidden:false];
    
    }
  // delete [] buffer2;
    
   //[myImage release];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
-(void) dealloc
{
    [saveAsNewBtn release];
    [imageView release];
    [super dealloc];

}
@end
