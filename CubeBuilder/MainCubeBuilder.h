//
//  MainCubeBuilder.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_MainCubeBuilder_h
#define CubeBuilder_MainCubeBuilder_h
#include "SettingsCubeBuilder.h"


#include "FlatRenderer.h"
#include "CubeRenderer.h"
#include "CubeHandler.h"
#include "InterfaceHandler.h"
#include "BackGround.h"

#include "npTweener.h"
#include "npTouch.h"
#include "npTouchEvent.h"
#include "PreviewCube.h"

#include "Camera.h"
#include "Model.h"
//#define USEAO 0

class MainCubeBuilder: public npEventDispatcher
{
public:
    MainCubeBuilder(){currentorientation =100;isGuesturing=false;};
    
    void setup1();
     void setup2();
     void setup3();
    void start();
    void update1();
    void update2();
    void update();
    void draw();
    void setTouches(vector<npTouch> &touches);
    void setOrientation(int orientation);
    void becameActive(npEvent *e);
    
    
    int currentorientation;
    
    
    FlatRenderer * flatRenderer;
    
    CubeRenderer * cubeRenderer;
    PreviewCube *previewCube;
    
    CubeHandler * cubeHandler;
    InterfaceHandler *interfaceHandler;
    BackGround *backGround;
    
    Camera * camera;
    Model *model;
    bool isDirty;
   
    vector <npTouch*> gestureTouches;
    bool isGuesturing;
    void resolveGesture();
    float startX;
    float startY;
    float startDist;
    int pixelW;
    int pixelH;
};



#endif
