//
//  Camera.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 28/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "Camera.h"


#include <algorithm>

Camera::Camera()
{
    
    model = Model::getInstance();
    
  /* objectMatrixTemp.makeIdentityMatrix();
    objectMatrixTemp.set(0.8348, 0.322234, -0.446401, 0,
                         -0.063531, 0.861789, 0.503273, 0,
                         0.546874, -0.391774, 0.739894, 0,
                         0, 0, 0, 1);
    
    */
    
    
    tempRotY=30; 
   currentRotY =30;
    tempRotX =60;
     currentRotX =60;
    
    normalMatrix.makeIdentityMatrix();
    worldMatrix.makeIdentityMatrix();
    centerMatrix.makeIdentityMatrix();
    
    currentCenterX =0;
    currentCenterY =0;
    currentCenterZ =0;
    
    zoom =-3;
    
    centerMatrix.setTranslation( currentCenterX,  currentCenterY,  currentCenterZ);
    
    perspectiveMatrix.makePerspectiveMatrix(60.0,768.0/1024.0,0.1, 200.0);
    
    isDirty =true;
    
    touchPointer =NULL;
    slerp =-1;
    didMove =true;
    
};
void Camera::update()
{
    if (!isDirty) return;

  
    if (slerp != -1)
    {
        quatFinal.slerp(slerp,    quatTarget,quatStart);        
        quatFinal.get(normalMatrix);
     
        if(slerp ==0){slerp=-1;   model->renderHit =true;};
    }else
    {
    
        normalMatrix.makeIdentityMatrix();
        normalMatrix.postMultRotate(tempRotY, 1, 0, 0);
        
        normalMatrix.preMultRotate(-tempRotX, 0, 1, 0)  ;
    
    }
   // cout<<"\n\n" << objectMatrixTemp;
    
    
    zoomMatrix.makeIdentityMatrix();
    zoomMatrix.translate(0.0,0,zoom*zoom*-1 );
    
   /*
    centerMatrix.setTranslation( currentCenterX,  currentCenterY,  currentCenterZ);
    
    worldMatrix.makeIdentityMatrix();
     
 
    
    normalMatrix.set(objectMatrixTemp);
    
    
    worldMatrix.preMult(zoomMatrix);
    worldMatrix.preMult(objectMatrixTemp);
    worldMatrix.preMult(centerMatrix);
    
    isDirty =false;*/
    
    
    
    centerMatrix.setTranslation( currentCenterX,  currentCenterY,  currentCenterZ);
    
    worldMatrix.makeIdentityMatrix();
    
    
    
   
    
    
    worldMatrix.preMult(zoomMatrix);
    worldMatrix.preMult( normalMatrix);
    worldMatrix.preMult(centerMatrix);
    
    
    setDepthRange();
    
    
    isDirty =false;
}

void Camera::checkTouch(npTouch &touch)
{
    
    if (model->currentState ==STATE_ROTATE){
    
        if(!touchPointer)
        {
            if( touch.phase==0)
            {
                         
              startRotate(touch.x,touch.y);
                touchPointer =&touch;

            }
        }   
        else if ( touchPointer ==&touch)
        {
            if( touch.phase==1)
            {
              setRotate(touch.x,touch.y);
                 didMove =true;
            }
            if( touch.phase==2)
            {
               stopRotate(touch.x,touch.y);
                touchPointer =NULL;
            }
        }
    }else
    {
      
        if( touch.phase==0)
        {

            touchPointer =&touch;
            
            prevX =touch.x;
            prevY =touch.y;  
            
            
        }
        else
        {
        
            float factor  =!(10<minDepth)?10:minDepth;
            //cout << " "<<factor;
            float moveX =  touch.x-prevX;
            float moveY = prevY -touch.y;
        
            ofVec4f vecX= normalMatrix.postMult(ofVec4f(1,0,0,0));
            vecX/=1000;
            vecX*=moveX*(factor);
        
            ofVec4f vecY= normalMatrix.postMult(ofVec4f(0,1,0,0));
            vecY/=1000;
            vecY*=moveY*(factor);
        
            currentCenterX+=vecX.x +vecY.x;
            currentCenterY +=vecX.y+vecY.y;
            currentCenterZ += vecX.z+vecY.z;
            
            
            prevX =touch.x;
            prevY =touch.y;  

             didMove =true;
            isDirty =true;
            if( touch.phase==2)
            {   
                touchPointer =NULL;
            }

        }
    }
    
}
/// OLD REAL TRACKBALL-> SUCKS
/*
void Camera::setRotate(int lx,int ly)
{
    v1 = trackBallMapping(lx,ly);
    v2 = trackBallMapping(prevX, prevY);
    
    rotAxis = v2.getCross(v1);
    float rotAngle = v2.dot(v1);
    objectMatrixTemp.rotate(-rotAngle*1.0, rotAxis.x, rotAxis.y, rotAxis.z);
    prevX =lx;
    prevY =ly;
    isDirty =true;
   

}
ofVec4f Camera::trackBallMapping(int pointX,int pointY)
{
    ofVec4f v;
    v.x = ((float)pointX -1024.0/2.0) / 1024.0 ;
    v.y = ((float)pointY -1024.0/2.0 ) / 1024.0;
    v.z = 0.0;
    v.w =0;
    float  d =v.length();
    v.z = sqrtf(1.000 - d*d);
    v.normalize();
    
    return v;
    
}
void Camera::stopRotate(int lx,int ly)
{
    
    
    v1 = trackBallMapping(lx,ly);
    v2 = trackBallMapping(prevX, prevY);
    
    rotAxis = v1.getCross(v2);
    float rotAngle = v1.dot(v2);
    objectMatrixTemp.rotate(-rotAngle*1.0, rotAxis.x, rotAxis.y, rotAxis.z);
  
    
    prevX =lx;
    prevY =ly;
    isDirty =true;
    
      
    
}
void Camera::startRotate(int lx,int ly)
{
    prevX = lx;
    prevY =ly;
   
    
}*/
void Camera::setRotate(int lx,int ly)
{
    
    int ofX = panXStart-lx;
    int ofY = panYStart-ly;
    tempRotY = currentRotY -(ofY/4.0);
     tempRotX = currentRotX +(ofX/4.0);
    // cout<<"\nrot " << tempRotX << " " <<tempRotY<< "\n";
if(tempRotY<-90) tempRotY=-90;
    if(tempRotY>90) tempRotY=90;
   // makeMatrix(tempRotX,tempRotY);
    
    isDirty =true;
    
}
void Camera::stopRotate(int lx,int ly)
{
    
    int ofX = panXStart-lx;
    int ofY = panYStart-ly;
    tempRotY = currentRotY -(ofY/4.0);
    tempRotX = currentRotX +(ofX/4.0);
    if(tempRotY<-89) tempRotY=-89;
    if(tempRotY>90) tempRotY=90;
    
    currentRotX =tempRotX;
    currentRotY =tempRotY;
 
      isDirty =true;
    
}
void Camera::startRotate(int lx,int ly)
{
   
    panXStart = lx;
    panYStart =ly;
    
}
 void makeMatrix(int lx,int ly);
void Camera::setOrientation(int orientation)
{ 
    if (orientation==0)
    {
        perspectiveMatrix.makePerspectiveMatrix(60.0,768.0/1024.0,0.1, 1000.0);
    }
    else
    {
        perspectiveMatrix.makePerspectiveMatrix(45.0,1024.0/768,0.1, 1000.0);        
    }
    currentOrientation =orientation;
    isDirty =true;
}









void Camera::setView(int viewID){

    //fit();
    
    ofMatrix4x4 target;
    
    
    if (viewID ==0)
    {
        tempRotX =0;
        tempRotY =0;
        
    }else  if (viewID ==1)

    {
        tempRotX =180;
        tempRotY =0;
    
    }
    else  if (viewID ==2)
        
    {
        tempRotX =0;
        tempRotY =90;
        
    }
    else  if (viewID ==3)
        
    {
        tempRotX =0;
        tempRotY =-90;
        
    }
    else  if (viewID ==4)
        
    {
        tempRotX =-90;
         tempRotY =0;
        
    }
    else  if (viewID ==5)
        
    {
          tempRotX =90;
         tempRotY =0;
        
    }
    currentRotX  =tempRotX;
    currentRotY =tempRotY;
   target.makeIdentityMatrix();
   target.postMultRotate(tempRotY, 1, 0, 0);
    
    target.preMultRotate(-tempRotX, 0, 1, 0)  ;

    quatStart.set(normalMatrix);
    quatTarget.set( target);
    
    
    
    
    
    slerp =1;
    npTween mijnTween;
    mijnTween.init(this,NP_EASE_OUT_SINE,300,0);
    
    mijnTween.addProperty(&slerp,0);
    npTweener::addTween(mijnTween,false);
   
    
    
  


}
void Camera::reset()
{

    tempRotY=30; 
    currentRotY =30;
    tempRotX =60;
    currentRotX =60;
    isDirty =true;
    normalMatrix.makeIdentityMatrix();
    normalMatrix.postMultRotate(tempRotY, 1, 0, 0);
    
    normalMatrix.preMultRotate(-tempRotX, 0, 1, 0)  ;

}
void Camera::fit(bool dotween,int lock){
    

    if(lock==1){
        tempzoom =zoom *zoom*-1  ;
         cout  << "start "<< zoom << " " << tempzoom <<endl;
        centerMatrix.setTranslation( -model->center.x,  -model->center.y, -model->center.z);
         worldMatrix.makeIdentityMatrix();
        worldMatrix.preMult(zoomMatrix);
        worldMatrix.preMult( normalMatrix);
        worldMatrix.preMult(centerMatrix);
    }

    float w =1.0f;
    
    ofVec4f lbb = model->min +ofVec4f(-0.5,-0.5,-0.5,0);
    ofVec4f rtf = model->max +ofVec4f(+0.5,+0.5,+0.5,0); 
    
   
   
    
    lbb.w =w;
    rtf.w =w;
    
    
    ofVec4f lbf ;
    lbf.set(lbb.x, lbb.y, rtf.z, w);
    
    ofVec4f rbf ;
    rbf.set(rtf.x, lbb.y, rtf.z, w);
    
    ofVec4f ltf ;
    ltf.set(lbb.x, rtf.y, rtf.z, w);
    
    
    ofVec4f rtb ;
    rtb.set(rtf.x, rtf.y, lbb.z, w);
    
    ofVec4f ltb ;
    ltb.set(lbb.x, rtf.y, lbb.z, w);
    
    ofVec4f rbb ;
    rbb.set(rtf.x, lbb.y, lbb.z, w);
    maxx =-100000000;
    minx =100000000;
    
    maxy =-100000000;
    miny =100000000;
    project(lbb);
     project(rbb);
     project(ltb);
     project(rtb);

    project(lbf);
    project(rbf);
    project(ltf);
    project(rtf);
    float zoomf ;
    if (currentOrientation==0){
        
        maxy*=0.75;
         miny*=0.75;
       
    
    }else
    {
        maxx*=0.75;
        minx*=0.75;
     
    }
    float dx = maxx-minx;
    float dy =maxy-miny;
    zoomf =sqrtf ( (dx*dx)+(dy*dy) )/(4.0 * tan(45.0/360.0 *3.1415));
    tempzoom *=zoomf;
     
    if (lock!=0){
        worldMatrix.makeIdentityMatrix();
        zoomMatrix.makeIdentityMatrix();
        zoomMatrix.translate(0.0,0,tempzoom  );
        worldMatrix.preMult(zoomMatrix);
        worldMatrix.preMult( normalMatrix);
        worldMatrix.preMult(centerMatrix);
        return;
    }
    if (!dotween)
    {
       currentCenterX =-model->center.x;
        currentCenterY =-model->center.y;
        currentCenterZ =-model->center.z;
        centerMatrix.setTranslation( -model->center.x,  -model->center.y, -model->center.z);
        zoom  =tempzoom;
        isDirty =true;
        cout << "noTween\n";
    
    }else
    {
        npTween mijnTween;
        mijnTween.init(this,NP_EASE_OUT_SINE,400,0);
        cout  << "Tween "<< tempzoom <<endl;
        mijnTween.addProperty(&currentCenterX,-model->center.x);
        mijnTween.addProperty(&currentCenterY,-model->center.y);
        mijnTween.addProperty(&currentCenterZ,-model->center.z );
        mijnTween.addProperty(&zoom,sqrtf(-tempzoom)*-1);
        makeCallBack(Camera,setComplete,call );
        mijnTween.addEventListener( NP_TWEEN_COMPLETE , call);
        
        npTweener::addTween(mijnTween);
        didMove =false;
    
    
    }
   

}

void Camera::project(ofVec4f &vec )
{
    ofVec4f mpm= worldMatrix.preMult( vec);
     vec= perspectiveMatrix.preMult(  mpm);
    
    vec.w =0;
    vec.x/=vec.z;
    vec.y/=vec.z;
    
    
    if(vec.x<minx)minx =vec.x;
    if(vec.x>maxx)maxx =vec.x;
    
    if(vec.y<miny)miny =vec.y;
    if(vec.y>maxy)maxy =vec.y;
  
  
   // cout << "\n"<< vec;


}
void Camera::addjustCenter( ofVec3f adj)
{
      
    npTween mijnTween;
    mijnTween.init(this,NP_EASE_IN_SINE,150,0);
    
    mijnTween.addProperty(&currentCenterX,currentCenterX-adj.x*1 );
    mijnTween.addProperty(&currentCenterY,currentCenterY-adj.y *1  );
    mijnTween.addProperty(&currentCenterZ,currentCenterZ-adj.z  *1 );
 
    makeCallBack(Camera,setComplete,call );
    mijnTween.addEventListener( NP_TWEEN_COMPLETE , call);
    
    npTweener::addTween(mijnTween);
    didMove =true;
    
    
    
    
    
}


void Camera::setComplete(npEvent *e)
{
    model->renderHit =true;
}

void   Camera::setZoomMove(float move)
{
    zoom+= move/20;
    if (zoom>-2)zoom =-2;
    isDirty =true;
    didMove =true;
}





void  Camera::setDepthRange()
{
    
    
    ofVec4f lbb = model->min +ofVec4f(-0.5,-0.5,-0.5,0);
    ofVec4f rtf = model->max +ofVec4f(+0.5,+0.5,+0.5,0); 
    
    
    float w =1;
    
    lbb.w =w;
    rtf.w =w;
    
    
    ofVec4f lbf ;
    lbf.set(lbb.x, lbb.y, rtf.z, w);
    
    ofVec4f rbf ;
    rbf.set(rtf.x, lbb.y, rtf.z, w);
    
    ofVec4f ltf ;
    ltf.set(lbb.x, rtf.y, rtf.z, w);
    
    
    ofVec4f rtb ;
    rtb.set(rtf.x, rtf.y, lbb.z, w);
    
    ofVec4f ltb ;
    ltb.set(lbb.x, rtf.y, lbb.z, w);
    
    ofVec4f rbb ;
    rbb.set(rtf.x, lbb.y, lbb.z, w);
    
    
  maxDepth =-100000000;
   
    
 
   minDepth=100000000;
    projectD(lbb);
    projectD(rbb);
    projectD(ltb);
    projectD(rtb);
    
    projectD(lbf);
    projectD(rbf);
    projectD(ltf);
    projectD(rtf);
    
//minDepth
//depthRange
    
    depthRange = maxDepth-minDepth;
   
}    
void Camera::projectD (ofVec4f vec )
{
    ofVec4f mpm= worldMatrix.preMult( vec);
    vec= perspectiveMatrix.preMult(  mpm);
    

    
    
    if(vec.z<minDepth)minDepth =vec.z;
    if(vec.z>maxDepth)maxDepth=vec.z;
    
  
    
    // cout << "\n"<< vec;
    
    
}
