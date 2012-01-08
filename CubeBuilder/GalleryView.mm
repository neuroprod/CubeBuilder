//
//  GalleryView.m
//  CubeConstruct
//
//  Created by Kris Temmerman on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GalleryView.h"
#import "SaveDataModel.h"
#import "HorImageGal.h"

#include "Model.h"
@implementation GalleryView
@synthesize gal;
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


- (void)loadView
{
    
    
    
}



- (void)viewDidLoad
{
 

    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    Model * model =Model::getInstance();
    model->isDirty =true;
    
   [[SaveDataModel getInstance] getAllData];
    
    gal =[[HorImageGal alloc] init];
    CGRect frame = self.view.frame;
    gal.view.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    gal.view .frame = CGRectMake(0, 0, frame.size.width, frame.size.height);   
 gal.arr =  [[SaveDataModel getInstance] savedData ];
    [self.view addSubview:gal.view];

  
  // [gal release];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"unloadscroll");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
-(void)dealloc
{
    [gal release];
    [super dealloc];
}
@end
