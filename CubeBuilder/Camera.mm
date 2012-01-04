//
//  Camera.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 28/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "Camera.h"




Camera::Camera()
{
    
    model = Model::getInstance();
    
    objectMatrixTemp.makeIdentityMatrix();
    objectMatrixTemp.set(0.8348, 0.322234, -0.446401, 0,
                         -0.063531, 0.861789, 0.503273, 0,
                         0.546874, -0.391774, 0.739894, 0,
                         0, 0, 0, 1);
    
    
    normalMatrix.makeIdentityMatrix();
    worldMatrix.makeIdentityMatrix();
    centerMatrix.makeIdentityMatrix();
    
    currentCenterX =0;
    currentCenterY =0;
    currentCenterZ =0;
    
    zoom =-10;
    
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
        quatFinal.get(objectMatrixTemp);
        if(slerp ==0)slerp=-1;
    }
   // cout<<"\n\n" << objectMatrixTemp;
    
    
    zoomMatrix.makeIdentityMatrix();
    zoomMatrix.translate(0.0,0,zoom );
    
    
    centerMatrix.setTranslation( currentCenterX,  currentCenterY,  currentCenterZ);
    
    worldMatrix.makeIdentityMatrix();
     
    
    normalMatrix.set(objectMatrixTemp);
    
    
    worldMatrix.preMult(zoomMatrix);
    worldMatrix.preMult(objectMatrixTemp);
    worldMatrix.preMult(centerMatrix);
    
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
        
           
            float moveX =  touch.x-prevX;
            float moveY = prevY -touch.y;
        
            ofVec4f vecX= normalMatrix.postMult(ofVec4f(1,0,0,0));
            vecX/=100;
            vecX*=moveX;
        
            ofVec4f vecY= normalMatrix.postMult(ofVec4f(0,1,0,0));
            vecY/=100;
            vecY*=moveY;
        
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
   
    
}


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
    isDirty =true;
}









void Camera::setView(int viewID){

    fit();
    
    ofMatrix4x4 target;
    
    
    if (viewID ==0)
    {
        target.makeIdentityMatrix();
        
    }else  if (viewID ==1)

    {
        target.makeRotationMatrix(180, ofVec3f(0,1,0));
    
    }
    else  if (viewID ==2)
        
    {
        target.makeRotationMatrix(90, ofVec3f(1,0,0));
        
    }
    else  if (viewID ==3)
        
    {
        target.makeRotationMatrix(-90, ofVec3f(1,0,0));
        
    }
    else  if (viewID ==4)
        
    {
        target.makeRotationMatrix(90, ofVec3f(0,1,0));
        
    }
    else  if (viewID ==5)
        
    {
        target.makeRotationMatrix(-90, ofVec3f(0,1,0));
        
    }
    quatStart.set( objectMatrixTemp);
    quatTarget.set( target);
    
    
    
    
    
    slerp =1;
    npTween mijnTween;
    mijnTween.init(this,NP_EASE_OUT_SINE,300,0);
    
    mijnTween.addProperty(&slerp,0);
    npTweener::addTween(mijnTween,false);
   
    
    
  


}
void Camera::fit(){
    
    
    float dist = model->min.distance(model->max)*-1.5f; // 1,5 is guess->use sin rule to fix
    if (dist>-5) dist =-5;
    npTween mijnTween;
    mijnTween.init(this,NP_EASE_OUT_SINE,400,0);
    
    mijnTween.addProperty(&currentCenterX,-model->center.x);
    mijnTween.addProperty(&currentCenterY,-model->center.y );
    mijnTween.addProperty(&currentCenterZ,-model->center.z );
    mijnTween.addProperty(&zoom,dist  );
    makeCallBack(Camera,setComplete,call );
    mijnTween.addEventListener( NP_TWEEN_COMPLETE , call);
      
    npTweener::addTween(mijnTween);
didMove =false;


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





