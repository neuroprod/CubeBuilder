//
//  PreviewCube.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 02/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_PreviewCube_h
#define CubeBuilder_PreviewCube_h

#include "SettingsCubeBuilder.h"
#include "npDirty.h"
#include "npTweener.h"
#include "npProgramLoader.h"
#include "Camera.h"
#include "Model.h"
#include "cbColor.h"
class Model;
class PreviewCube:public npDirty
{

    GLuint programMain;
    GLint uWorldMatrixMain;
    GLint uPerspectiveMatrixMain;
    GLint uColor;
    GLint uPosition;
    float * data;
    
    
    int colorID;
public:
    PreviewCube(){};
    
    void setup();
    
    void setPos(float _x, float _y, float _z);
    void setColor(int _colorID);
    void update();
    void draw();

    float x;
    float y;
    float z;
    
    float r;
    float g;
    float b;
    bool isShow;
    
    Model *model;
    int numi ;
};


#endif
