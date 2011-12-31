//
//  npDLRenderer.h
//  displaylist
//
//  Created by Kris Temmerman on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npDLRenderer_h
#define displaylist_npDLRenderer_h


#include "npDisplayList.h"
#include "npDisplayObject.h"

#include "npProgramLoader.h" 
#include "OpenGLErrorChek.h"
class npDLRenderer
{

public:
    npDLRenderer();
    ~npDLRenderer(); 
    void setup();
    
    bool  update(npDisplayObject * displayObject);
    void render(npDisplayObject * displayObject);
    void setSize(float w,float h);
private:
    GLuint program;
    GLint uWorldMatrix;
     ofMatrix4x4 worldMatrix;
protected:




};


#endif
