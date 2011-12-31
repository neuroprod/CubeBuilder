//
//  npBitmapSprite.h
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npBitmapSprite_h
#define displaylist_npBitmapSprite_h



#include "npDisplayObject.h"


class npBitmapSprite: public npDisplayObject
{
protected:
    
    
    float uvX;
    float uvY;
    float uvWidth;
    float uvHeight;
    
    
   
    
    ofVec4f p1;
    ofVec4f p2;
    ofVec4f p3;
    ofVec4f p4;
    
    
    
    ofVec4f p1t;
    ofVec4f   p2t;
    ofVec4f p3t;
    ofVec4f p4t;

    float width;
    float height;
    
    virtual bool isTouching(npTouch &touch);
public:
    npBitmapSprite():npDisplayObject(){};
    ~npBitmapSprite(){} ;

    void setSize(int w , int h);
    void setSize(int w , int h, int x,int y );
    void setSize(int w , int h,int align);
  virtual  void setUVauto(int posX , int posY,int  uvSizeW,int uvSizeH);
   virtual void setUV(float u  , float v ,float  uSize,float vSize);
    
    
    
    
    float data [36];
    virtual bool update(bool parentIsDirty );
    virtual void getData( vector <float> &vec );
    virtual void resetData();

 
};

#endif
