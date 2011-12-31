//
//  ViewController.m
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#include "MainCubeBuilder.h"
#include <iostream>
#include <vector>
#include "npTouch.h"


#define BUFFER_OFFSET(i) ((char *)NULL + (i))



@interface ViewController ()  {
  
    MainCubeBuilder *main ;
    vector <UITouch *> itouches;
    vector <npTouch > ntouches;


}
@property (strong, nonatomic) EAGLContext *context;


- (void)setupGL;
- (void)tearDownGL;
-(void)  updateTouche:(int) index;

@end

@implementation ViewController

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
    main =new MainCubeBuilder();
    main->setup();
    
    
  
    
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
            ntouches.erase (ntouches.begin()+i );
            itouches.erase (itouches.begin()+i );
            i--;
        }
        
    }
    
    
}


@end
