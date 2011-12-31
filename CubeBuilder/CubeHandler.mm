//
//  CubeHandler.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "CubeHandler.h"
void CubeHandler::setup()
{
    currentColor.set(1,0,0);
      
    cubes.clear();
    model = Model::getInstance();
    
}
void CubeHandler::touchedCube(int cubeIndex,int cubeSide,int touchPhase)
{

    if (model->currentState==STATE_ADD )
    {
       
        if (touchPhase == NP_TOUCH_STOP)
        {
            //cout << " \ntouchADD" << touchPhase << " "<< cubeSide<<" "<<cubeIndex <<" \n";
            ofVec3f pos   =  cubes[cubeIndex]->pos;
            if (cubeSide==110)addCube(pos.x+1 , pos.y, pos.z);
            if (cubeSide==120)addCube(pos.x-1 , pos.y, pos.z);
    
            if (cubeSide==130)addCube(pos.x , pos.y+1, pos.z);
            if (cubeSide==140)addCube(pos.x , pos.y-1, pos.z);
        
            if (cubeSide==150)addCube(pos.x , pos.y, pos.z+1);
            if (cubeSide==160)addCube(pos.x , pos.y, pos.z-1);
           
        }
    
    }






}
void CubeHandler::addCube(float x, float y, float z)
{
    Cube *cube =new Cube();
    cube->setup(cubes.size(),x,y,z,currentColor);
  
    cubes.push_back(cube );
   
    if (model->min.x>x)
    {
        model->min.x =x;
    
    }
    if (model->max.x<x)
    {
        model->max.x =x;
        
    }
    if (model->min.y>y)
    {
        model->min.y =y;
        
    }
    if (model->max.y<y)
    {
        model->max.y =y;
        
    }
    
    if (model->min.z>z)
    {
        model->min.z =z;
        
    }
    if (model->max.z<z)
    {
        model->max.z =z;
        
    }
    
    model->resolveCenter();
    
    
    //memcpy( cube->data, &vertexData[0], sizeof( float) * 288 );   
   
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
  
    glBufferSubData(GL_ARRAY_BUFFER, sizeof( float) * 288 * cube->cubeIndex, sizeof( GLfloat)*288, cube->data);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    isDirty =true;
    model->renderHit =true;
   
 
  
}
void CubeHandler::removeCube(int index)
{


    isDirty =true;
}
void CubeHandler::setCubeColor(int index,cbColor color)
{

    isDirty =true;

}

void CubeHandler::clean()
{

    isDirty =true;
}


void CubeHandler::setColor(int colorid)
{
    currentColor =model->colors[colorid];
}


void CubeHandler::update()
{
    
   
}