//
//  ViewController.m
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ClearView.h"
#import "LoadView.h"

#include "MainCubeBuilder.h"
#include "SaveDataModel.h"
#include <iostream>
#include <vector>
#include "npTouch.h"


#define BUFFER_OFFSET(i) ((char *)NULL + (i))



@interface ViewController ()  {
  
    ClearView *clearView;
  // LoadView *loadView;
    MainCubeBuilder *main ;
    vector <UITouch *> itouches;
    vector <npTouch > ntouches;


}
@property (strong, nonatomic) EAGLContext *context;

@property (retain,nonatomic) ClearView *clearView;
//@property (retain,nonatomic) LoadView *loadView;
@property (retain,nonatomic) SaveDataModel *saveData;


- (void)setupGL;
- (void)tearDownGL;
-(void)  updateTouche:(int) index;
-(void) showView:(NSInteger)viewID;
@end

@implementation ViewController



@synthesize saveData;
//@synthesize loadView;
@synthesize clearView;

@synthesize context = _context;
- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.multipleTouchEnabled =true;
    [self setupGL];
    
    saveData= [SaveDataModel getInstance];
    [saveData initDB];
    
    
    main =new MainCubeBuilder();
    main->setup();
    
    
    

    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOverView:) name:@"setOverView" object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOverView:) name:@"hideOverView" object:nil];
    
}

-(void )hideOverView:(NSNotification *) notification
{
  if (self.clearView.view.superview  ){
  
        [self.clearView.view removeFromSuperview];
        //[self.clearView release];
        //self.clearView =NULL;
    }
    
 

    
}
-(void )setOverView:(NSNotification *) notification
{
    NSNumber *data  =notification.object;
    
    [self showView:[data intValue ]];
    
}
-(void) showView:(NSInteger)viewID
{
    if (viewID==10)
    {
        if (self.clearView ==NULL){
        ClearView *clearV = [[ClearView alloc] initWithNibName:@"ClearView" bundle:nil];
        self.clearView = clearV;
        clearView.view.frame = CGRectMake(100, 100, 400, 400);
     
        [clearV release];
        }
        
        [self.view insertSubview:clearView.view atIndex:0];
    }
    
  else  if (viewID==2)
    {
      /* NSLog(@"show Load");
      if (self.loadView ==NULL){
            LoadView *loadV = [[LoadView alloc] initWithNibName:@"LoadView" bundle:nil];
            self.loadView = loadV;
           //self loadView.view.frame = CGRectMake(100, 100, 400, 400);
            
            [loadV release];
        }
        
        [self.view insertSubview:loadView.view atIndex:0];*/
    }
    main->isDirty =true;

}
- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
  
    if (!main) return YES;
 
    if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown  || interfaceOrientation == UIInterfaceOrientationPortrait )
    {
        
        main->setOrientation(0);
        
    
    }else
    {
        
       main->setOrientation(1);
    
    }
    return YES;
  
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
       
  }

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
     main->update();
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{

    main->draw();
  
    
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
   
    for (UITouch *itouch in touches) 
    {
        itouches.size();
        bool found = false;
        
        for(int i=0;i< itouches.size();i++)
        {
            if(itouches[i] == itouch)
            {
                
                [self updateTouche:i];
                found=true;
                break;
                
            }
            
        }
        if(!found)
        {
            itouches.push_back(itouch);
            npTouch::npTouch touch; 
            touch.phase =0;
            ntouches.push_back(touch);
            [self updateTouche:itouches.size()-1];
            
        }
        
    }
   main->setTouches(ntouches);
    
}
-(void)  updateTouche:(int) index
{
   
    UITouch * itouch =  itouches[index];
    
    CGPoint location = [itouch locationInView:self.view];
    
    ntouches[index].x  = location.x;
    ntouches[index].y   = location.y;
    ntouches[index].phase =  itouch.phase;
    
    if ( ntouches[index].phase>2 )ntouches[index].phase=2;
    
    
    
    
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for (UITouch *itouch in touches) 
    {
        itouches.size();
       // bool found = false;
        
        for(int i=0;i< itouches.size();i++)
        {
            if(itouches[i] == itouch)
            {
                
                [self updateTouche:i];
                //found=true;
                break;
                
            }
            
        }
        
    }
    main->setTouches(ntouches);
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *itouch in touches) 
    {
        itouches.size();
        //bool found = false;
        
        for(int i=0;i< itouches.size();i++)
        {
            if(itouches[i] == itouch)
            {
                ntouches[i ].markDelete =true;
                [self updateTouche:i];
                //found=true;
                break;
                
            }
            
        }
        
    }
    main->setTouches(ntouches);
    //clean;
    for(int i=0;i< itouches.size();++i)
    {
        if(ntouches[i].markDelete)
        {
            ntouches.erase (ntouches.begin()+i );
            itouches.erase (itouches.begin()+i );
             ntouches[i ].target =NULL;
            i--;
            
        }
        
    }
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *itouch in touches) 
    {
        itouches.size();
      //  bool found = false;
        
        for(int i=0;i< itouches.size();i++)
        {
            if(itouches[i] == itouch)
            {
                ntouches[i ].markDelete =true;
               
                [self updateTouche:i];
                //found=true;
                
                break;
                
            }
            
        }
        
    }
    main->setTouches(ntouches);
    //clean;
    for(int i=0;i< itouches.size();++i)
    {
        if(ntouches[i].markDelete)
        {
             ntouches[i ].target =NULL;
            ntouches.erase (ntouches.begin()+i );
            itouches.erase (itouches.begin()+i );
            i--;
        }
        
    }
    
    
}


@end
