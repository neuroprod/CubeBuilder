//
//  BackGround.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_BackGround_h
#define CubeBuilder_BackGround_h
#include "SettingsCubeBuilder.h"

class BackGround
{
    GLuint fbo;
    GLuint flatTexture;
    GLuint texture;
    
    float *renderData;
    GLuint rbuffer;
    
public:
    
    BackGround(){isDirty=true;};
    void setup();
    void setColor();
    void renderTick();
    void prepForFlatDraw();
    
    
    bool isDirty;


};



#endif
