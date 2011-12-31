//
//  FlatRenderer.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_FlatRenderer_h
#define CubeBuilder_FlatRenderer_h

#include "SettingsCubeBuilder.h"
#include "ofMatrix4x4.h"
class FlatRenderer
{

private:
    GLuint program;
    GLint uWorldMatrix;
    ofMatrix4x4 worldMatrix;
 float * data;


public:
    FlatRenderer(){};
    void  setup();
    
    
    void start();
    
    void draw();
    
    void stop();
    
    void setOrientation(int orientation);





};

#endif
