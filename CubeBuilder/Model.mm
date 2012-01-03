
//
//  Model.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 27/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "Model.h"

Model* Model::m_pSingleton = NULL;

Model::Model() { currentState = -1;

   renderHit =true;
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
 
    
    cubeHandler->setColor(colorid);
   colorHolder->setColor(colorid);
    colorMenu->setColor(colorid);

}