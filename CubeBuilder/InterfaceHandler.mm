//
//  InterFaceHandler.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "InterfaceHandler.h"
void InterfaceHandler::setup()
{
    dlRenderer.setup();
    
    display.setup();
    display.isDirty =true;

    vpW = 1024;
    vpH=768;
    
    glGenTextures(1, &flatTexture);
	glBindTexture(GL_TEXTURE_2D, flatTexture);
	
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    int width =1024;
    int height =1024;
	
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    
   // glGenRenderbuffers(1, &rbuffer);
	//glBindRenderbuffer(GL_RENDERBUFFER, rbuffer);
	//glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
	
	glGenFramebuffers(1, &fbo);
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, flatTexture, 0);
    
   
}

void InterfaceHandler::renderTick()
{
    
 
       
    if ( dlRenderer.update(&display) || isDirty)
    {
        //display.isDirty =false;
        isDirty =true;
    
      
        glBindFramebuffer(GL_FRAMEBUFFER, fbo);   
        glViewport(0, 0, vpW, vpH);
        glClear(GL_COLOR_BUFFER_BIT| GL_DEPTH_BUFFER_BIT);
        dlRenderer.render (&display);   
        
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
  
    }
}
void InterfaceHandler::prepForFlatDraw()
{
    glBindTexture(GL_TEXTURE_2D, flatTexture);
    isDirty =false ;


}

bool InterfaceHandler::checkTouch(npTouch &touch)
{
    if (Model::getInstance()->firstRun)return false;
    return display.checkTouch(touch);
}


void InterfaceHandler::setOrientation(int orientation)
{
    isDirty =true;
    display.setOrientation( orientation);
    if (orientation ==1)
    {
        vpW = 1024;
        vpH=1024;
    }
    else
    {
        vpW = 1024;
        vpH=1024;
        
    }
    dlRenderer.setSize(vpW, vpH);
   
}