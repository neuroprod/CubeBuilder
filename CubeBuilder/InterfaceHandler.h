//
//  InterfaceHandler.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_InterfaceHandler_h
#define CubeBuilder_InterfaceHandler_h

#include "SettingsCubeBuilder.h"
#include "UIdisplaylist.h"
#include "npDLRenderer.h"



class InterfaceHandler
{
    
    GLuint fbo;
    GLuint flatTexture;
 
    GLuint rbuffer;
    
  
    npDLRenderer dlRenderer;
    
    int vpW ;
    int vpH;
   
public:
    
      UIdisplaylist display;
    InterfaceHandler(){isDirty =true;}
    void setup();
    void renderTick();
    void prepForFlatDraw();
   
    bool checkTouch(npTouch &touch);
    
     bool isDirty;
    
    void setOrientation(int orientation);
  
    
};


#endif
