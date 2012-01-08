//
//  npDisplayObject.cpp
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "npDisplayObject.h"
bool  npDisplayObject::checkTouch(npTouch &touch)
{
    if(!visible)return false;
    if(touchChildren){
   
    for (int i=numChildren-1; i>=0 ;i--)
    {
        if( children[i]->checkTouch(touch)) return true;
    }
    }
    if(!touchEnabled)return false;
    
    return isTouching(touch);

}

void npDisplayObject::addChild(npDisplayObject &dp)
{
    
    dp.parent  =this;
    children.push_back(&dp);
    numChildren = children.size();
   
}
void npDisplayObject::removeChild(npDisplayObject &dp)
{
    int index =  getChildIndex(dp);
    children[index]->parent  =NULL;
    children.erase (children.begin()+index);
    numChildren = children.size();
}

bool  npDisplayObject::update(bool parentIsDirty )
{
   
    if(!visible)return parentIsDirty ;
     onEnterFrame();
    
    bool pDirty =false;
    if(isDirty)
    {
        updateLocalMatrix();
        parentIsDirty  =true;
        pDirty =true;
    }
    
    if(parentIsDirty)
    {
        resetData();
        
    }
    
   
  
    
    for (int i=0; i< numChildren ;i++)
    {
        if( children[i]->update(parentIsDirty))pDirty =true;
        
    }
    
    isDirty =false;
    return pDirty;

}
void npDisplayObject::resetData()
{
    globalMatrix  = localMatrix;
    if(parent )
    {
        renderalpha  =alpha*parent->renderalpha;
        globalMatrix*=parent->globalMatrix;
    }else
    {
        renderalpha  =alpha;
        
    }
}
void npDisplayObject::updateLocalMatrix()
{
    
    
 
//blabla do transform
    localMatrix.makeTranslationMatrix(x, y, z);
   // localMatrix.makeIdentityMatrix();
    //localMatrix.glTranslate (x,y,z);
    if(rotation!=0)
    localMatrix.glRotate(rotation, 0, 0, 1);
    if(scale!=1)
    localMatrix.glScale(scale, scale, 0);
};

void npDisplayObject::getData( vector <float> &vec )
{
  if(!visible)return;
   
    for(int i=0; i<numChildren;i++)
    {
        
        children[i]->getData(vec);
    }

}
int npDisplayObject::getChildIndex(npDisplayObject &dp)
{

    npDisplayObject * pointer = &dp;
    
    int i ;
    for (i =0;i< numChildren;++i)
    {
        if(children[i ] == pointer ) return i;
    
    
    }
   
    return -1;
}

npDisplayObject& npDisplayObject::getChildAt(int index)
{
    
 
    
   
   
    
    return *children[index] ;
    
}

