//
//  Camera.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 26/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_Camera_h
#define CubeBuilder_Camera_h


#include "ofMatrix4x4.h"
#include "npDirty.h"
#include "npTouch.h"
#include "ofVec4f.h"
#include "ofVec3f.h"

#include "npTweener.h"
#include "Model.h"
class Model;


class Camera: public npDirty
{
    Model *model;
   
   
    
    ofMatrix4x4 zoomMatrix;
    ofMatrix4x4 centerMatrix;
    ofMatrix4x4 objectMatrixTemp;
       
    
    ofVec4f rotAxis;
    ofVec4f v1;
    ofVec4f v2;
    float prevX;
    float prevY;
    
    float currentCenterX;
    
    float currentCenterY;
    float currentCenterZ;
    
    
    ofQuaternion quatTarget;
    ofQuaternion quatStart;
    ofQuaternion quatFinal;
    
    float slerp;
    int currentOrientation;
    
    
    int panXStart;
    int panYStart;
    float rot;
    float currentRotX ;
    float currentRotY;
    float tempRotY ;
    float tempRotX; 
    
    
    float minx;
    float maxx;
    float miny;
    float maxy;
public:
    
     npTouch * touchPointer;
    ofMatrix4x4 normalMatrix;
    ofMatrix4x4 worldMatrix;
    ofMatrix4x4 perspectiveMatrix;
    
    float zoom;
    bool didMove;
    
    Camera();
    void update();
    void checkTouch(npTouch &touch);
    
    void stopRotate(int lx,int ly);
    void startRotate(int lx,int ly);
    void setRotate(int lx,int ly);
    ofVec4f trackBallMapping(int pointX,int pointY);
    
    void setOrientation(int orientation);
   
    
    void setView(int viewID);
    void fit(bool dotween =true,int lock=0);
    void setComplete(npEvent *e);
    void addjustCenter( ofVec3f adj);
    
    void reset();
  void   setZoomMove(float move);
    float tempzoom;
    void project(ofVec4f &vec );
};

#endif
