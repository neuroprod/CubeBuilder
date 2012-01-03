//
//  CubeHandler.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_CubeHandler_h
#define CubeBuilder_CubeHandler_h

#include "SettingsCubeBuilder.h"
#include "Cube.h"
#include "Model.h"
#include "PreviewCube.h"
class PreviewCube;
class Model;
class CubeHandler
{
    
    Model *model;
    
public:
    CubeHandler(){};
    void setup();
    void update();
    
    
    void touchedCube(int cubeIndex,int cubeSide,int touchPhase);
    
    
    void addCube(float x, float y, float z);
    void removeCube(int index);
    void setCubeColor(int index);
    
    void clean();
    
    void setColor(int colorid);
 
    cbColor currentColor;
    
    GLfloat vertexData[518400];
    GLuint vertexBuffer;
    
    vector <Cube *> cubes ;
    PreviewCube * previewCube;
    
    bool isDirty;
};


#endif
