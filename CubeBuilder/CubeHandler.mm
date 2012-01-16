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
    doClean =false;
    lockUndo =false;
    isRedo =false;
    currentColor.set(1,0,0);
    currentColor.colorID =24;
    cubes.clear();
    model = Model::getInstance();
    
    makeCallBack( CubeHandler,tryUndo ,undoCall );
    model->undoBtn->addEventListener( TOUCH_UP_INSIDE, undoCall );   
    
    makeCallBack( CubeHandler,tryRedo ,redoCall );
    model->redoBtn->addEventListener( TOUCH_UP_INSIDE, redoCall );   
    
}
void CubeHandler::touchedCube(int cubeIndex,int cubeSide,int touchPhase)
{

    if (model->currentState==STATE_ADD )
    {
       
        if (touchPhase == NP_TOUCH_STOP)
        {
            if(cubeIndex> cubes.size()-1 && cubeIndex<0)return;
             previewCube->setPos(10000 , 10000, 10000);
            //cout << " \ntouchADD" << touchPhase << " "<< cubeSide<<" "<<cubeIndex <<" \n";
            ofVec3f pos   =  cubes[cubeIndex]->pos;
            if (cubeSide==110)addCube(pos.x+1 , pos.y, pos.z);
            if (cubeSide==120)addCube(pos.x-1 , pos.y, pos.z);
    
            if (cubeSide==130)addCube(pos.x , pos.y+1, pos.z);
            if (cubeSide==140)addCube(pos.x , pos.y-1, pos.z);
        
            if (cubeSide==150)addCube(pos.x , pos.y, pos.z+1);
            if (cubeSide==160)addCube(pos.x , pos.y, pos.z-1);
             Model::getInstance()->playSound(SOUND_ADD_CUBE);
            doClean =true;
           
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
             Model::getInstance()->playSound(SOUND_REMOVE_CUBE);
            
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
               Model::getInstance()->playSound(SOUND_PAINT_CUBE);
        }else 
        {
        
             previewCube->setColor(currentColor.colorID);
            
            ofVec3f pos   =  cubes[cubeIndex]->pos;
            previewCube->setPos(pos.x*2.0 , pos.y*2.0, pos.z*2.0);
        }
       
       
    }


}

void CubeHandler::clearCubes()
{
    cubes.clear();
    model->max.set(0, 0,0);
    model->min.set(0, 0  ,0);
   addCube(0, 0, 0,true);
  
    
resetUndo();
} 

void CubeHandler::addCube(float x, float y, float z,bool isClear)
{
   
    int s =cubes.size();
    if (s !=0){
        Cube *cubeT  =cubes[s-1];
        if (cubeT->x ==x && cubeT->y == y && cubeT->z ==z )
        {
    
            cout << "Mother f**king cube on that plane!!!\n";
            // only check last cube?? 
            return;
        }
    }
    
    Cube *cube =new Cube();
    cube->setup(s ,x,y,z,currentColor);
    
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
    
    if (isClear)return;
    
    UndoObj und;
    
    und.index = s;
    und.colorID = cube->colorID;
    und.x = cube->x;
    und.y = cube->y;
    und.z = cube->z;
    und.action =0;
    addToUndo(und);
   // undoVec.push_back(und );
  
}
void CubeHandler::removeCube(int index)
{
    
    Cube *cube =cubes[index];
    
    UndoObj und;
    und.index = index;
    und.colorID = cube->colorID;
    und.x = cube->x;
    und.y = cube->y;
    und.z = cube->z;
    und.action =1;
    addToUndo(und);
    
    
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
    if (currentColor.colorID ==cube->colorID)return;
    
    UndoObj und;
    und.index = index;
    und.colorID =currentColor.colorID;
    und.colorIDOld = cube->colorID;
    und.x = cube->x;
    und.y = cube->y;
    und.z = cube->z;
    und.action =2;
    addToUndo(und);
    
    
    cube->setCubeColor(currentColor);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glBufferSubData(GL_ARRAY_BUFFER, sizeof( float) * 288 * cube->cubeIndex, sizeof( GLfloat)*288, cube->data);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
   
    
    isDirty =true;

}

void CubeHandler::clean()
{
    if (!doClean)return;
  
    int l =cubes.size();
    int l1 =l-1;
    int j ;
    for (int i =0; i<l1;i++)
    {
        Cube *cube1 = cubes [i ];
        for ( j =i+1; i<l;i++)
        {
            Cube *cube2 = cubes [j ];
            
            if(cube2->x ==cube1->x)
            {
                if(cube2->y ==cube1->y)
                {
                    if(cube2->z ==cube1->z)
                    {
                       cout << "FOOUUUUND";
                    }
                }
            }
            
        }
    }
     cout<< "\n";
    doClean =false;
  //  isDirty =true;
}


void CubeHandler::setColor(int colorid)
{
    if(colorid != currentColor.colorID) 
  currentColor =model->colors[colorid];

}

int * CubeHandler::getCubeData()
{
    int size = cubes.size() ;
    int * data = new int[size *4];
    for(int i=0;i<size;i++)
    {
        int pos  =i*4;
        data[pos] =cubes[i]->colorID;
        data[pos+1] =cubes[i]->x;
        data[pos+2] =cubes[i]->y;
        data[pos+3] =cubes[i]->z;
    }
    return data;


}
void CubeHandler::setLoadData(int *dataCube,int size)
{
    cubes.clear();
    model->max.set(-10000, -10000,-10000);
    model->min.set(10000, 10000  ,10000);
  
    

    for (int i=0;i<size/4;i++)
    {
        int pos =i*4;
        setColor(dataCube[pos]);
        addCube(dataCube[pos+1], dataCube[pos+2], dataCube[pos+3],true);
    
    }
    model->resolveCenter();
    resetUndo();
}
void CubeHandler::update()
{
    
   
}





///
//
//
//
//
///
void CubeHandler::addToUndo(UndoObj und )
{
    if (lockUndo)
    {
          
        redoVec.push_back(und );
        model->redoBtn->setEnabled(true);
    
    }else{
        if (cubes.size()==1 && und.action != 2)return;
       
        undoVec.push_back(und );
        model->undoBtn->setEnabled(true);
        
        
        
        if (undoVec.size()>100)undoVec.erase(undoVec.begin());// max 100 undos...
        
        if (!isRedo)
        {
            if (redoVec.size()!=0){
            redoVec.clear();
            model->redoBtn->setEnabled(false);        
            }
        }
    }
}
void CubeHandler::tryUndo( npEvent *e)
{
    if (undoVec.size()==1)model->undoBtn->setEnabled(false);  
    lockUndo =true;
    
    UndoObj und = undoVec[undoVec.size()-1];
    undoVec.pop_back();
    //ADD
    if(und.action ==0)
    {
    
        Cube *cube  =cubes[und.index];
        
        if (cube->x ==und.x && cube->y == und.y && cube->z ==und.z )
        {
            removeCube(und.index);
        }
        else 
        {
            int l = cubes.size();
            int newIndex;
            for (int i=l-1;i>=0;i --)
            {
                
                Cube *cubeS =cubes[i ];
                if (cubeS->x ==und.x && cubeS->y == und.y && cubeS->z ==und.z )
                {
                    newIndex = i;
                    break;
                    
                }
            }
                
            removeCube(newIndex);
        
        }
    
    }else if (und.action ==1)
    {
        setColor(und.colorID);
        addCube(und.x, und.y, und.z);
    
    }else if (und.action==2)
    {
        
        Cube *cube  =cubes[und.index];
        
        if (cube->x ==und.x && cube->y == und.y && cube->z ==und.z ){
        
            setColor(und.colorIDOld);
            setCubeColor(und.index);
        }else
        {
            setColor(und.colorIDOld);
            int l = cubes.size();
            int newIndex;
            for (int i=l-1;i>=0;i --)
            {
            
                Cube *cubeS =cubes[i ];
                if (cubeS->x ==und.x && cubeS->y == und.y && cubeS->z ==und.z )
                {
                    newIndex = i;
                    break;
                
                }
            }
            
         
            setCubeColor(newIndex);
        
        
        }
    }

    
    lockUndo =false;

}
void CubeHandler::tryRedo( npEvent *e)
{
    isRedo =true;
    if (redoVec.size()==1){model->redoBtn->setEnabled(false);  };
  

    UndoObj und = redoVec[redoVec.size()-1];
    redoVec.erase(redoVec.end()-1);
    //ADD
    if(und.action ==0)
    {
        //if (und.index>cubes.size())
        Cube *cube  =cubes[und.index];
        
        if (cube->x ==und.x && cube->y == und.y && cube->z ==und.z )
        {
            removeCube(und.index);
        }
        else 
        {
            int l = cubes.size();
            int newIndex;
            for (int i=l-1;i>=0;i --)
            {
                
                Cube *cubeS =cubes[i ];
                if (cubeS->x ==und.x && cubeS->y == und.y && cubeS->z ==und.z )
                {
                    newIndex = i;
                    break;
                    
                }
            }
            cout << "\nADD WAS FAIL, But UPDATED?????\n";         
            removeCube(newIndex);
            
        }
        
    }else if (und.action ==1)
    {
        setColor(und.colorID);
        addCube(und.x, und.y, und.z);
        
    }else if (und.action==2)
    {
        
        Cube *cube  =cubes[und.index];
        
        if (cube->x ==und.x && cube->y == und.y && cube->z ==und.z ){
            
            setColor(und.colorIDOld);
            setCubeColor(und.index);
        }else
        {
            setColor(und.colorIDOld);
            int l = cubes.size();
            int newIndex;
            for (int i=l-1;i>=0;i --)
            {
                
                Cube *cubeS =cubes[i ];
                if (cubeS->x ==und.x && cubeS->y == und.y && cubeS->z ==und.z )
                {
                    newIndex = i;
                    break;
                    
                }
            }
            
            cout << "\nWHAS FAIL, But UPDATED?????\n";
            setCubeColor(newIndex);
            
            
        }
    }
    isRedo= false;    
   //lockUndo =false;

}

void CubeHandler::resetUndo()
{
    model->undoBtn->setEnabled(false);  
    model->redoBtn->setEnabled(false);  
    redoVec.clear();
    undoVec.clear();
    
}
