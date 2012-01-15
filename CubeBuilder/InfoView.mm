//
//  InfoView.m
//  CubeConstruct
//
//  Created by Kris Temmerman on 14/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoView.h"
#include "Model.h"
@implementation InfoView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"ikbeninfo");
    }
    return self;
}
- (IBAction)help:(id)sender{

[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.cubeconstruct.net/support"]];
}
-(IBAction)cube:(id)sender{

[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.cubeconstruct.net"]];

}
-(IBAction)neuro :(id)sender{

[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.neuroproductions.be"]];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)viewDidAppear:(BOOL)animated
{
    Model * model =Model::getInstance();
    model->isDirty =true;
    
    
}
#pragma mark - View lifecycle

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

@end
