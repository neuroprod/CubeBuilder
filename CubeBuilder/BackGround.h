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
#include "ofMatrix4x4.h"
class BackGround
{
    GLuint fbo;
    GLuint flatTexture;
    GLuint texture;
    
    float *renderData;
    GLuint rbuffer;
    
    GLuint program;
    GLint uWorldMatrix;
    ofMatrix4x4 worldMatrix;
    float * data;
public:
    
    BackGround(){isDirty=true;};
    void setup();
    void setColor();
    void renderTick();
    void prepForFlatDraw();
    void setOrientation(int orientation);
    
    bool isDirty;


};



#endif
