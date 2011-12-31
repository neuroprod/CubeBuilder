//
//  CubeRenderer.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_CubeRenderer_h
#define CubeBuilder_CubeRenderer_h
#include "SettingsCubeBuilder.h"
#include "CubeHandler.h"
#include "npProgramLoader.h"
#include "Camera.h"
#include "Model.h"


class CubeRenderer
{

    GLuint fbo;
    GLuint flatTexture;
    GLuint rbuffer;

    GLuint sampleFramebuffer;
    GLuint sampleColorRenderbuffer;
    GLuint sampleDepthRenderbuffer;
    
    
    GLuint indexBuffer;
    GLushort * indexData;
    GLfloat * vertexData;
    
    
    GLuint programMain;
    GLint uWorldMatrixMain;
    GLint uNormalMatrixMain;
    GLint uPerspectiveMatrixMain;
    
    
    GLuint programID;
    GLint uWorldMatrixID;
    GLint uNormalMatrixID;
    GLint uPerspectiveMatrixID;
    
    GLubyte *pixels;
    Model * model;
    
    
    GLuint fboDepth;
    GLuint rbufferDepth;
    GLuint programDepth;
     GLuint textureDepth;
    GLint uWorldMatrixDepth;
    GLint uPerspectiveMatrixDepth;
    
    
    GLuint fboBlur;
    GLuint rbufferBlur;
    GLuint programBlur;
    GLuint textureBlur;
    GLint uWorldMatrixBlur;
    
    float *data;
    ofMatrix4x4 worldMatrixBlur;
public:
    
    
    
    CubeRenderer(){isDirty=true; vpW = 1024;vpH=768;}
    void setup();
    void update();
    
    void renderTick();
    
    void prepForFlatDraw();
    void setOrientation(int orientation);
    void drawIDS();
    
    void setupIDCubes();
  
    void drawIDcubes();
 
    bool getPoint(int x, int y );
    
    int currentCubeIndex;
    int currentCubeSide;
    
    bool isDirty ;
    
    GLuint vertexBuffer;
    CubeHandler *cubeHandler;
    
    Camera * camera;
    
    int vpW;
    int vpH;
    int vpY;
    
    
    
    
    bool useAO ;
    
    void setupAO();
    void renderAO();
   void prepForAODraw();
};

#endif
