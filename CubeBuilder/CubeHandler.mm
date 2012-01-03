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
            
             previewCube->setPos(10000 , 10000, 10000);
            //cout << " \ntouchADD" << touchPhase << " "<< cubeSide<<" "<<cubeIndex <<" \n";
            ofVec3f pos   =  cubes[cubeIndex]->pos;
            if (cubeSide==110)addCube(pos.x+1 , pos.y, pos.z);
            if (cubeSide==120)addCube(pos.x-1 , pos.y, pos.z);
    
            if (cubeSide==130)addCube(pos.x , pos.y+1, pos.z);
            if (cubeSide==140)addCube(pos.x , pos.y-1, pos.z);
        
            if (cubeSide==150)addCube(pos.x , pos.y, pos.z+1);
            if (cubeSide==160)addCube(pos.x , pos.y, pos.z-1);
            
           
        }else 
        {
         previewCube->setColor(currentColor.colorID);
            
            ofVec3f pos   =  cubes[cubeIndex]->pos;
            if (cubeSide==110)previewCube->setPos((pos.x+1) *2, pos.y*2, pos.z*2);
            if (cubeSide==120)previewCube->setPos((pos.x-1)*2 , pos.y*2, pos.z*2);
            
            if (cubeSide==130)previewCube->setPos(pos.x*2 , (pos.y+1)*2, pos.z*2);
            if (cubeSide==140)previewCube->setPos(pos.x*2 , (pos.y-1)*2, pos.z*2);
            
            if (cubeSide==150)previewCube->setPos(pos.x*2 , pos.y*2, (pos.z+1)*2);
            if (cubeSide==160)previewCube->setPos(pos.x*2 , pos.y*2, (pos.z-1)*2);

        
        }
    
    }

    if (model->currentState==STATE_REMOVE )
    {
        
        if (touchPhase == NP_TOUCH_STOP)
        {
            //cout << " \ntouchADD" << touchPhase << " "<< cubeSide<<" "<<cubeIndex <<" \n";
            removeCube(cubeIndex);
            previewCube->setPos(10000 , 10000, 10000);
            
        }else
        {
            
            previewCube->setColor(-1);
        
            ofVec3f pos   =  cubes[cubeIndex]->pos;
           previewCube->setPos(pos.x*2.0 , pos.y*2.0, pos.z*2.0);

        }
        
    }


    if (model->currentState==STATE_PAINT )
    {
       
        if (touchPhase == NP_TOUCH_STOP)
        {
            setCubeColor(cubeIndex);
            previewCube->setPos(10000 , 10000, 10000);
            
        }else 
        {
        
             previewCube->setColor(currentColor.colorID);
            
            ofVec3f pos   =  cubes[cubeIndex]->pos;
            previewCube->setPos(pos.x*2.0 , pos.y*2.0, pos.z*2.0);
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

    int l =cubes.size();
    if (l==1)return;
    if (index+1 == l)
    {
        //last cube = no buffer update;
        cubes.pop_back();
    }else
    {
    
        cubes.erase(cubes.begin()+index);
        
       // float data[cubes.size()-index];
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        
        
        //optimize:: first in array -> one buffersub; 
        for (int i =index; i<l;i++)
        {
            Cube *cube = cubes [i ];
            cube->setCubeIndex(i);
        glBufferSubData(GL_ARRAY_BUFFER, sizeof( float) * 288 * cube->cubeIndex, sizeof( GLfloat)*288, cube->data);
        
        }
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    
    
    
    
    }
    l-=1;
    model->max.set(-100000, -100000,-100000);
    model->min.set(100000, 100000  ,100000);
    for (int i =0; i<l;i++)
    {
        Cube *cube = cubes [i ];
        float x = cube->pos.x;
        float y = cube->pos.y;
        float z = cube->pos.z;
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
        
    }
    
    model->resolveCenter();
    model->renderHit =true;
    isDirty =true;
}
void CubeHandler::setCubeColor(int index)
{
    Cube *cube =cubes[index];
    cube->setCubeColor(currentColor);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glBufferSubData(GL_ARRAY_BUFFER, sizeof( float) * 288 * cube->cubeIndex, sizeof( GLfloat)*288, cube->data);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
   
    
    isDirty =true;

}

void CubeHandler::clean()
{

    isDirty =true;
}


void CubeHandler::setColor(int colorid)
{
    
    currentColor =model->colors[colorid];
    cout << "setcolor " << currentColor.colorID;
}


void CubeHandler::update()
{
    
   
}