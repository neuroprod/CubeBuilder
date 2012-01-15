
//
//  Model.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 27/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "Model.h"
#import <AudioToolbox/AudioToolbox.h>





Model* Model::m_pSingleton = NULL;

Model::Model() { 
    currentLoadID =-1;
    currentState = -1;
    takeSnapshot  =false;
    pixeldata =NULL;
    renderHit =true;
    useAO =false;
    keepAO =false;
    isSound =false;
}
Model::~Model() { }

Model* Model::getInstance()
{
    if(m_pSingleton == NULL)
        m_pSingleton = new Model;
    
    return m_pSingleton;
}
void Model::setCurrentState(int state )
{

   if (currentState>10 && currentState<20 && state<10)renderHit =true;
    
    currentState =state;



}
void Model::prepForSaveShow()
{
    snapType =0;
     useAO =true;
    takeSnapshot =true;
    
}
void Model::prepForSaveImage()
{
    snapType=1;
    useAO =true;
  takeSnapshot =true;

}
void Model::clearCubes ()
{
     currentLoadID =-1;
    isDirty =true;
   // setColor(24);// red;
    cubeHandler->clearCubes();
    camera->zoom = -3;
    camera->reset();
    colorMenu->resetColors();
    setColor(24);
}
void  Model::playSound(int soundID)
{
    if (isSound)return;
    NSString *path;
    
    if (soundID == SOUND_ADD_CUBE){
        path = [[NSBundle mainBundle] pathForResource:@"woody_click" ofType:@"wav"];
    }else if (soundID == SOUND_HIT_BTN){
        path = [[NSBundle mainBundle] pathForResource:@"pop_click2" ofType:@"wav"];
    }else if (soundID == SOUND_CAMERA){
        path = [[NSBundle mainBundle] pathForResource:@"Camera" ofType:@"mp3"];
    }
    else 
    {return;}
   
  
        SystemSoundID audioEffect;
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
   
   
}
void  Model::setLoadData(int *dataCube,int size)
{

    cubeHandler->setLoadData(dataCube,size);
    
    cancelOverlay();
    
    resolveCenter();
    camera->reset();
    camera->fit(false,1);
    camera->fit(false,2);
    camera->fit(false,3);
    camera->zoom =camera->tempzoom*2.0;
    camera->fit(true,0);
      
    
      colorMenu->resetColors();
    setColor(24);
}


void Model::cancelOverlay()
{

    npEvent e;
    e.name = "cancelOverlay";
    dispatchEvent(e);
   

}
void Model::becameActive()
{

    npEvent e;
    e.name = "becameActive";
    dispatchEvent(e);


}
void  Model::resolveCenter()
{

    center.x = (max.x+min.x)/2;
    center.y = (max.y+min.y)/2;
    center.z = (max.z+min.z)/2;
     
    if(!center.match(centerOld))
    {
        ofVec3f adj = center - centerOld;
        camera->addjustCenter(adj);
        
    }
    
    
    centerOld.set(center);
        
}



void Model::setColor(int colorid)
{
 
    cancelOverlay();
    cubeHandler->setColor(colorid);
   colorHolder->setColor(colorid);
    colorMenu->setColor(colorid);

}