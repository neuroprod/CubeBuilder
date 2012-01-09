//
//  ViewController.m
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ClearView.h"
#import "SaveView.h"
#import "GalleryView.h"

#include "MainCubeBuilder.h"
#include "SaveDataModel.h"
#include <iostream>
#include <vector>
#include "npTouch.h"
#include "ViewSettings.h"





@interface ViewController ()  {
  
    
   
    
    ClearView *clearView;
   SaveView *saveView;
   GalleryView *galView;
    
    
    
    
    MainCubeBuilder *main ;
    vector <UITouch *> itouches;
    vector <npTouch > ntouches;
    int width2;
    int height2;

}
@property (strong, nonatomic) EAGLContext *context;

@property (retain,nonatomic) ClearView *clearView;
@property (retain,nonatomic) SaveView *saveView;
@property (retain,nonatomic)  GalleryView *galView;
@property (retain,nonatomic) SaveDataModel *saveData;


- (void)setupGL;
- (void)tearDownGL;
-(void)  updateTouche:(int) index;
-(void) showView:(NSInteger)viewID;
@end

@implementation ViewController



@synthesize saveData;
@synthesize saveView;
@synthesize clearView;
@synthesize galView;
@synthesize context = _context;
- (void)viewDidLoad
{
   
    [super viewDidLoad];
    cout<<"\n " ;
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		
	{	
          cout<<"hascam " ;
        Model::getInstance()->isIpad1 =false;
          
        
    }
    else {
    
      cout<<"hasnocam " ;
       Model::getInstance()->isIpad1 =true ;
    }
    cout<<"\n " ;
    
    
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
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
      [clearView release];
      clearView=NULL;
        
    }
   else if (self.saveView.view.superview  ){
        
        [self.saveView.view removeFromSuperview];
       
       [saveView release];
       saveView =NULL;
        
   }    else if (self.galView.view.superview  ){
       
       [self.galView.view removeFromSuperview];
       [galView release];
       galView =NULL;
       
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
      
        [clearV release];
        }
       clearView.view.frame = CGRectMake(width2-CLEARVIEW_WIDHT/2, height2-CLEARVIEW_HEIGHT/2, CLEARVIEW_WIDHT, CLEARVIEW_HEIGHT);       
        [self.view insertSubview:clearView.view atIndex:0];
    }
    
  else  if (viewID==11)
    {
        if (self.saveView ==NULL){
            SaveView *clearV = [[SaveView alloc] initWithNibName:@"SaveView" bundle:nil];
            self.saveView = clearV;
           // saveView.view.frame = CGRectMake(width2-SAVEVIEW_WIDHT/2, height2-SAVEVIEW_HEIGHT/2, SAVEVIEW_WIDHT, SAVEVIEW_HEIGHT);
            
            [clearV release];
        }
          saveView.view.frame = CGRectMake(width2-SAVEVIEW_WIDHT/2, height2-SAVEVIEW_HEIGHT/2, SAVEVIEW_WIDHT, SAVEVIEW_HEIGHT);
        [self.view insertSubview:saveView.view atIndex:0];
    }
  else  if (viewID==12)
  {
      if (self.galView ==NULL){
         GalleryView *clearV =  [[ GalleryView alloc] init];
          clearV.view = [[UIView alloc] initWithFrame:CGRectMake(0, height2-LOADVIEW_HEIGHT/2, width2*2, LOADVIEW_HEIGHT)];
          
          self.galView = clearV;
                  
          [clearV release];
      }
      NSLog(@"setBackGround");
      
       
     galView.view.frame = CGRectMake(0, height2-LOADVIEW_HEIGHT/2, width2*2, LOADVIEW_HEIGHT);
      [self.view insertSubview:galView.view atIndex:0];
      
  }
   

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
        width2 =768/2;
        height2 =1024/2;
    
    }else
    {
        width2 =1024/2;
        height2 =768/2;
       main->setOrientation(1);
    
    }
    
    if (self.saveView !=NULL){saveView.view.frame = CGRectMake(width2-SAVEVIEW_WIDHT/2, height2-SAVEVIEW_HEIGHT/2, SAVEVIEW_WIDHT, SAVEVIEW_HEIGHT);}
     if (self.clearView !=NULL){clearView.view.frame = CGRectMake(width2-CLEARVIEW_WIDHT/2, height2-CLEARVIEW_HEIGHT/2, CLEARVIEW_WIDHT, CLEARVIEW_HEIGHT);}
    
    if (self.galView !=NULL){galView.view.frame =    CGRectMake(0, height2-LOADVIEW_HEIGHT/2, width2*2, LOADVIEW_HEIGHT);}
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
