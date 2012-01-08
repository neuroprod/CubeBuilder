//
//  npDisplayObject.h
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npDisplayObject_h
#define displaylist_npDisplayObject_h

#include "npDisplayList.h"
#include "npEventDispatcher.h"

#include "npTouchEvent.h"

#include "npTouch.h"
class npDisplayObject: public npEventDispatcher, public npDirty
{
    
   private: 
    
protected:
   
    
    vector < npDisplayObject *> children;
    
    
    ofMatrix4x4 localMatrix;
   
   
 
    
public:
    bool touchEnabled;
    bool touchChildren;
    bool visible;
     float renderalpha;
    float alpha;
    ofMatrix4x4 globalMatrix; 
    
    npDisplayObject() { setPos(0.0f,0.0f,0.0f) ;numChildren =0; parent =NULL ;texture =-1;scale =1;rotation=0 ;alpha=1;renderalpha=1;touchEnabled =true;touchChildren =true;visible =true;}

    void updateLocalMatrix();
    virtual void resetData();
    virtual void onEnterFrame(){};
   virtual bool update(bool parentIsDirty);
    virtual void getData( vector<float> &vec  );
    
    //virtual vector<float> getVertices();
    //virtual vector<int> getIndices();
    
    
    npDisplayObject *parent;
    
    GLuint texture;
    
    float x;
    float y;
    float z;
    float scale;
    float rotation;
    void setPos(float xValue,float yValue,float zValue =0) {x =xValue; y =yValue; z = zValue; isDirty=true; };
    
    
    bool checkTouch(npTouch &touch);
    virtual bool isTouching(npTouch &touch){return false;};
    
    
    int numChildren;
    virtual void addChild(npDisplayObject &dp);
    virtual void removeChild(npDisplayObject &dp);
    virtual int getChildIndex(npDisplayObject &dp);
    virtual npDisplayObject& getChildAt(int index);
    
    
    
    

    
    




};


#endif
